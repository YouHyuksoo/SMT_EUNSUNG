$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$script:DefaultDeployRoot = 'D:\Project\SMT_EUNSUNG\.deploy'
$script:ExpectedOutputs = @(
  'packages/shared/dist/index.js',
  'apps/backend/dist/main.js',
  'apps/frontend/.next/BUILD_ID'
)
$script:NonSecretConfigFiles = @(
  'ecosystem.config.js',
  'package.json',
  'pnpm-lock.yaml',
  'scripts/deploy/windows/EunsungDeployment.psm1',
  'scripts/deploy/windows/Deploy-EunsungRelease.ps1',
  'scripts/deploy/windows/Test-EunsungDeployment.ps1'
)
$script:AppPorts = [ordered]@{
  'eunsung-frontend' = 3100
  'eunsung-backend' = 3003
}

function Test-EunsungCommitSha {
  [CmdletBinding()]
  param([Parameter(Mandatory)][string]$CommitSha)
  return $CommitSha -cmatch '^[0-9a-f]{40}$'
}

function Resolve-EunsungContainedPath {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$Root,
    [Parameter(Mandatory)][string]$Candidate,
    [switch]$AllowMissing
  )

  $rootFull = [IO.Path]::GetFullPath($Root).TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
  if (-not (Test-Path -LiteralPath $rootFull) -and -not $AllowMissing) {
    throw "Deployment root does not exist: $rootFull"
  }
  if (Test-Path -LiteralPath $rootFull) {
    $rootFull = (Resolve-Path -LiteralPath $rootFull).ProviderPath.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
  }

  $candidateFull = [IO.Path]::GetFullPath($Candidate)
  if (Test-Path -LiteralPath $candidateFull) {
    $candidateFull = (Resolve-Path -LiteralPath $candidateFull).ProviderPath
  } elseif (-not $AllowMissing) {
    throw "Deployment path does not exist: $candidateFull"
  }

  $prefix = $rootFull + [IO.Path]::DirectorySeparatorChar
  if (($candidateFull -ne $rootFull) -and (-not $candidateFull.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase))) {
    throw "Deployment path is outside the deployment root"
  }
  return $candidateFull
}

function Get-EunsungFileAttributes {
  param([string]$Path, [scriptblock]$AttributeProvider)
  if ($AttributeProvider) { return & $AttributeProvider $Path }
  return [IO.File]::GetAttributes($Path)
}

function Assert-EunsungNoReparseAncestry {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$Root,
    [Parameter(Mandatory)][string]$Target,
    [scriptblock]$AttributeProvider
  )

  $rootFull = [IO.Path]::GetFullPath($Root).TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
  $targetFull = [IO.Path]::GetFullPath($Target).TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
  $prefix = $rootFull + [IO.Path]::DirectorySeparatorChar
  if (($targetFull -ne $rootFull) -and (-not $targetFull.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase))) {
    throw 'Deployment path is outside the deployment root'
  }
  $cursor = $targetFull
  while ($true) {
    if (Test-Path -LiteralPath $cursor) {
      $attributes = Get-EunsungFileAttributes -Path $cursor -AttributeProvider $AttributeProvider
      if (($attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw "Deployment path contains a reparse point"
      }
    }
    if ($cursor -eq $rootFull) { break }
    $parent = Split-Path -Parent $cursor
    if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $cursor) {
      throw "Deployment ancestry escaped the deployment root"
    }
    $cursor = $parent.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
  }
}

function Assert-EunsungNoReparsePath {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$Path,
    [scriptblock]$AttributeProvider
  )

  $cursor = [IO.Path]::GetFullPath($Path)
  while ($true) {
    if (Test-Path -LiteralPath $cursor) {
      $attributes = Get-EunsungFileAttributes -Path $cursor -AttributeProvider $AttributeProvider
      if (($attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw 'Deployment path contains a reparse point'
      }
    }
    $parent = Split-Path -Parent $cursor
    if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $cursor) { break }
    $cursor = $parent
  }
}

function Assert-EunsungOrdinaryFile {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$Path,
    [scriptblock]$AttributeProvider
  )

  if (-not [IO.File]::Exists($Path)) {
    throw "Expected an ordinary file"
  }
  $attributes = Get-EunsungFileAttributes -Path $Path -AttributeProvider $AttributeProvider
  if (($attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
    throw "Protected file must not be a reparse point"
  }
  if (($attributes -band [IO.FileAttributes]::Directory) -ne 0) {
    throw "Expected an ordinary file"
  }
}

function ConvertTo-EunsungSanitizedDiagnostic {
  [CmdletBinding()]
  param([AllowNull()][object]$Diagnostic)

  if ($null -eq $Diagnostic) { return 'operation failed' }
  $safe = [string]$Diagnostic
  $safe = [regex]::Replace($safe, '(?i)"?\b([a-z0-9_-]*(?:password|passwd|pwd|secret|token|key|connectionstring)[a-z0-9_-]*)\b"?\s*[:=]\s*(?:"[^"]*"|''[^'']*''|\{[^}]*\}|[^\s,;]+)', '$1=[REDACTED]')
  $safe = [regex]::Replace($safe, '(?i)"?\b(env|config)\b"?\s*[:=]\s*(?:\{[^}]*\}|"[^"]*"|''[^'']*''|[^\s,;]+)', '$1=[REDACTED]')
  return $safe
}

function Invoke-EunsungNative {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$FilePath,
    [string[]]$Arguments = @(),
    [string]$WorkingDirectory,
    [hashtable]$Environment,
    [scriptblock]$NativeInvoker
  )

  if ($NativeInvoker) {
    $result = & $NativeInvoker $FilePath $Arguments $WorkingDirectory $Environment
    $exitCode = [int]$result.ExitCode
    $output = [string]$result.Output
  } else {
    $original = @{}
    if ($Environment) {
      foreach ($key in $Environment.Keys) {
        $original[$key] = [Environment]::GetEnvironmentVariable($key, 'Process')
        [Environment]::SetEnvironmentVariable($key, [string]$Environment[$key], 'Process')
      }
    }
    $oldLocation = Get-Location
    try {
      if ($WorkingDirectory) { Set-Location -LiteralPath $WorkingDirectory }
      $outputLines = & $FilePath @Arguments 2>&1
      $exitCode = $LASTEXITCODE
      $output = ($outputLines | ForEach-Object { [string]$_ }) -join [Environment]::NewLine
    } finally {
      Set-Location -LiteralPath $oldLocation
      if ($Environment) {
        foreach ($key in $Environment.Keys) {
          [Environment]::SetEnvironmentVariable($key, $original[$key], 'Process')
        }
      }
    }
  }

  if ($exitCode -ne 0) {
    # Native output can include the PM2 environment or package-manager config.
    # Preserve the checked exit code, but never echo untrusted command output.
    throw "Native command failed with exit code $exitCode"
  }
  return $output
}

function Invoke-EunsungBoundedHttp {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$Uri,
    [ValidateRange(1, 20)][int]$MaxAttempts = 5,
    [ValidateRange(1, 60)][int]$TimeoutSec = 5,
    [ValidateRange(0, 60000)][int]$RetryDelayMs = 1000,
    [scriptblock]$HttpInvoker,
    [scriptblock]$SleepAdapter
  )

  if (-not $HttpInvoker) {
    $HttpInvoker = {
      param($RequestUri, $RequestTimeoutSec)
      $response = Invoke-WebRequest -Uri $RequestUri -UseBasicParsing -TimeoutSec $RequestTimeoutSec
      return @{ StatusCode = [int]$response.StatusCode; Body = [string]$response.Content }
    }
  }
  if (-not $SleepAdapter) { $SleepAdapter = { param($Milliseconds) Start-Sleep -Milliseconds $Milliseconds } }

  $lastError = 'request failed'
  for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
    try {
      return & $HttpInvoker $Uri $TimeoutSec
    } catch {
      $lastError = ConvertTo-EunsungSanitizedDiagnostic $_.Exception.Message
      if ($attempt -lt $MaxAttempts) { & $SleepAdapter $RetryDelayMs }
    }
  }
  throw "HTTP request failed after $MaxAttempts attempts. $lastError"
}

function ConvertFrom-EunsungPm2Json {
  [CmdletBinding()]
  param([Parameter(Mandatory)][string]$Json)
  try {
    $apps = @($Json | ConvertFrom-Json)
  } catch {
    throw 'PM2 returned invalid JSON'
  }
  return $apps
}

function Test-EunsungReleaseHealth {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$ExpectedSha,
    [Parameter(Mandatory)][string]$ReleaseMarkerSha,
    [scriptblock]$Pm2ListProvider,
    [scriptblock]$PortOwnerProvider,
    [scriptblock]$HttpInvoker,
    [ValidateRange(1, 20)][int]$MaxAttempts = 5,
    [ValidateRange(1, 60)][int]$TimeoutSec = 5,
    [ValidateRange(0, 60000)][int]$RetryDelayMs = 1000,
    [scriptblock]$SleepAdapter
    ,[string]$ExpectedReleaseDir
    ,[string]$FrontendUrl = 'http://127.0.0.1:3100/'
    ,[string]$BackendUrl = 'http://127.0.0.1:3003/api/v1/health'
  )

  if (-not $Pm2ListProvider) {
    $Pm2ListProvider = { Invoke-EunsungNative -FilePath 'pm2.cmd' -Arguments @('jlist') }
  }
  if (-not $PortOwnerProvider) {
    $PortOwnerProvider = {
      param($Port)
      return @(Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction Stop | Select-Object -ExpandProperty OwningProcess -Unique)
    }
  }
  if (-not $HttpInvoker) {
    $HttpInvoker = {
      param($Uri, $RequestTimeoutSec)
      $response = Invoke-WebRequest -Uri $Uri -UseBasicParsing -TimeoutSec $RequestTimeoutSec
      return @{ StatusCode = [int]$response.StatusCode; Body = [string]$response.Content }
    }
  }
  if (-not $SleepAdapter) { $SleepAdapter = { param($Milliseconds) Start-Sleep -Milliseconds $Milliseconds } }
  $expectedReleaseFull = $null
  if (-not [string]::IsNullOrWhiteSpace($ExpectedReleaseDir)) {
    if (-not [IO.Directory]::Exists($ExpectedReleaseDir)) { throw 'Expected release directory does not exist' }
    $expectedReleaseFull = (Resolve-Path -LiteralPath $ExpectedReleaseDir).ProviderPath.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
  }

  $lastDiagnostics = @('health verification did not run')
  for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
    $diagnostics = New-Object System.Collections.Generic.List[string]
    try {
      if ($ReleaseMarkerSha -cne $ExpectedSha) { $diagnostics.Add('release marker does not exactly match expected SHA') }
      $apps = ConvertFrom-EunsungPm2Json -Json ([string](& $Pm2ListProvider))
      foreach ($entry in $script:AppPorts.GetEnumerator()) {
        $app = @($apps | Where-Object { $_.name -ceq $entry.Key })
        if ($app.Count -ne 1) {
          $diagnostics.Add("PM2 app missing or duplicated: $($entry.Key)")
          continue
        }
        if ([string]$app[0].pm2_env.status -cne 'online') {
          $diagnostics.Add("PM2 app is not online: $($entry.Key)")
        }
        if ($expectedReleaseFull) {
          foreach ($property in @('pm_cwd', 'pm_exec_path')) {
            $value = [string]$app[0].pm2_env.$property
            try { $valueFull = [IO.Path]::GetFullPath($value) } catch { $valueFull = '' }
            $prefix = $expectedReleaseFull + [IO.Path]::DirectorySeparatorChar
            if ([string]::IsNullOrWhiteSpace($value) -or (($valueFull -ne $expectedReleaseFull) -and (-not $valueFull.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase))) ) {
              $diagnostics.Add("PM2 app points outside expected release: $($entry.Key)/$property")
            }
          }
        }
        $pid = [int]$app[0].pid
        $owners = @(& $PortOwnerProvider ([int]$entry.Value))
        if ($pid -le 0 -or -not ($owners -contains $pid)) {
          $diagnostics.Add("PID does not own expected port: $($entry.Key):$($entry.Value)")
        }
      }

      $frontend = & $HttpInvoker $FrontendUrl $TimeoutSec
      if ([int]$frontend.StatusCode -lt 200 -or [int]$frontend.StatusCode -ge 400) {
        $diagnostics.Add('frontend HTTP request was not successful')
      }
      $backend = & $HttpInvoker $BackendUrl $TimeoutSec
      if ([int]$backend.StatusCode -ne 200) {
        $diagnostics.Add('backend health HTTP status was not 200')
      } else {
        try { $health = [string]$backend.Body | ConvertFrom-Json } catch { $health = $null }
        if ($null -eq $health -or [string]$health.status -cne 'ok') { $diagnostics.Add('backend health status is not ok') }
        if ($null -eq $health -or $null -eq $health.database -or [string]$health.database.status -cne 'connected') {
          $diagnostics.Add('backend database status is not connected')
        }
      }
    } catch {
      $diagnostics.Add((ConvertTo-EunsungSanitizedDiagnostic $_.Exception.Message))
    }

    if ($diagnostics.Count -eq 0) { return @{ Success = $true; Diagnostics = @(); Attempts = $attempt } }
    $lastDiagnostics = @($diagnostics | ForEach-Object { ConvertTo-EunsungSanitizedDiagnostic $_ })
    if ($attempt -lt $MaxAttempts) { & $SleepAdapter $RetryDelayMs }
  }
  return @{ Success = $false; Diagnostics = $lastDiagnostics; Attempts = $MaxAttempts }
}

function Get-EunsungConfigHashes {
  param([Parameter(Mandatory)][string]$ReleaseDir)
  $hashes = [ordered]@{}
  foreach ($relativePath in $script:NonSecretConfigFiles) {
    $path = Join-Path $ReleaseDir $relativePath
    Assert-EunsungOrdinaryFile -Path $path
    $hashes[$relativePath] = Get-EunsungFileSha256 -Path $path
  }
  return $hashes
}

function Get-EunsungFileSha256 {
  param([Parameter(Mandatory)][string]$Path)
  $stream = [IO.File]::Open($Path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::Read)
  $sha256 = [Security.Cryptography.SHA256]::Create()
  try {
    $bytes = $sha256.ComputeHash($stream)
    return ([BitConverter]::ToString($bytes)).Replace('-', '').ToLowerInvariant()
  } finally {
    $sha256.Dispose()
    $stream.Dispose()
  }
}

function Write-EunsungJsonAtomic {
  param([Parameter(Mandatory)][string]$Path, [Parameter(Mandatory)][object]$Value)
  $parent = Split-Path -Parent $Path
  if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  $temporary = "$Path.tmp-$([guid]::NewGuid().ToString('N'))"
  try {
    $Value | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $temporary -Encoding UTF8
    Move-Item -LiteralPath $temporary -Destination $Path -Force
  } finally {
    if (Test-Path -LiteralPath $temporary) { Remove-Item -LiteralPath $temporary -Force }
  }
}

function Write-EunsungBuildMarker {
  [CmdletBinding()]
  param([Parameter(Mandatory)][string]$ReleaseDir, [Parameter(Mandatory)][string]$CommitSha)
  if (-not (Test-EunsungCommitSha $CommitSha)) { throw 'CommitSha must be exactly 40 lowercase hexadecimal characters' }
  foreach ($relativePath in $script:ExpectedOutputs) { Assert-EunsungOrdinaryFile -Path (Join-Path $ReleaseDir $relativePath) }
  $marker = [ordered]@{
    commitSha = $CommitSha
    completedAtUtc = [DateTime]::UtcNow.ToString('o')
    expectedOutputs = @($script:ExpectedOutputs)
    configHashes = Get-EunsungConfigHashes -ReleaseDir $ReleaseDir
  }
  Write-EunsungJsonAtomic -Path (Join-Path $ReleaseDir 'build.complete.json') -Value $marker
}

function Resolve-EunsungIdentitySid {
  param([Parameter(Mandatory)][string]$Identity, [scriptblock]$SidResolver)
  if ($SidResolver) { return [string](& $SidResolver $Identity) }
  if ($Identity -cmatch '^S-\d+(?:-\d+)+$') { return $Identity }
  return ([Security.Principal.NTAccount]$Identity).Translate([Security.Principal.SecurityIdentifier]).Value
}

function Test-EunsungAclAccess {
  [CmdletBinding()]
  param([string]$Path, [scriptblock]$AclProvider, [scriptblock]$SidResolver)
  try {
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
      $stream = [IO.File]::Open($Path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::Read)
      $stream.Dispose()
    }
    if ($AclProvider) { $acl = & $AclProvider $Path } else { $acl = Get-Acl -LiteralPath $Path }
    $deploySid = Resolve-EunsungIdentitySid -Identity 'eunsung-deploy' -SidResolver $SidResolver
    $ownerSid = Resolve-EunsungIdentitySid -Identity ([string]$acl.Owner) -SidResolver $SidResolver
    $trustedSids = @('S-1-5-18', 'S-1-5-32-544', $deploySid)
    if ($trustedSids -notcontains $ownerSid) { return $false }
    $deployReadable = $false
    foreach ($rule in @($acl.Access)) {
      $identitySid = Resolve-EunsungIdentitySid -Identity ([string]$rule.IdentityReference) -SidResolver $SidResolver
      $rights = [Security.AccessControl.FileSystemRights]$rule.FileSystemRights
      $isAllow = [string]$rule.AccessControlType -eq 'Allow'
      $writeMask = [Security.AccessControl.FileSystemRights]::WriteData `
        -bor [Security.AccessControl.FileSystemRights]::CreateFiles `
        -bor [Security.AccessControl.FileSystemRights]::AppendData `
        -bor [Security.AccessControl.FileSystemRights]::CreateDirectories `
        -bor [Security.AccessControl.FileSystemRights]::WriteAttributes `
        -bor [Security.AccessControl.FileSystemRights]::WriteExtendedAttributes `
        -bor [Security.AccessControl.FileSystemRights]::Delete `
        -bor [Security.AccessControl.FileSystemRights]::DeleteSubdirectoriesAndFiles `
        -bor [Security.AccessControl.FileSystemRights]::ChangePermissions `
        -bor [Security.AccessControl.FileSystemRights]::TakeOwnership
      $canWrite = ($rights -band $writeMask) -ne 0
      if ($isAllow -and $identitySid -ceq $deploySid) { $deployReadable = $true }
      if ($isAllow -and $canWrite -and $trustedSids -notcontains $identitySid) { return $false }
    }
    return $deployReadable
  } catch {
    return $false
  }
}

function Assert-EunsungProtectedConfig {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$ReleaseDir,
    [scriptblock]$AccessValidator,
    [scriptblock]$AclProvider,
    [scriptblock]$SidResolver,
    [scriptblock]$AttributeProvider
  )
  if (-not $AccessValidator) { $AccessValidator = { param($Path) Test-EunsungAclAccess -Path $Path -AclProvider $AclProvider -SidResolver $SidResolver } }
  foreach ($relativePath in @('apps/backend/.env', 'apps/frontend/config/database.json')) {
    $path = Join-Path $ReleaseDir $relativePath
    Assert-EunsungNoReparseAncestry -Root $ReleaseDir -Target $path -AttributeProvider $AttributeProvider
    Assert-EunsungOrdinaryFile -Path $path -AttributeProvider $AttributeProvider
    $cursor = $path
    while ($true) {
      if (-not (& $AccessValidator $cursor)) { throw 'Protected deployment config ACL or access validation failed' }
      if ($cursor -eq $ReleaseDir) { break }
      $cursor = Split-Path -Parent $cursor
    }
  }
}

function Assert-EunsungBuiltRelease {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$DeployRoot,
    [Parameter(Mandatory)][string]$ReleaseDir,
    [Parameter(Mandatory)][string]$CommitSha,
    [scriptblock]$AccessValidator,
    [scriptblock]$AttributeProvider
  )
  if (-not (Test-EunsungCommitSha $CommitSha)) { throw 'CommitSha must be exactly 40 lowercase hexadecimal characters' }
  $releaseRoot = Join-Path $DeployRoot 'releases'
  $resolved = Resolve-EunsungContainedPath -Root $releaseRoot -Candidate $ReleaseDir
  Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $resolved -AttributeProvider $AttributeProvider
  if (-not [IO.Directory]::Exists($resolved)) { throw 'Release must be an ordinary directory' }
  $shaMarkerPath = Join-Path $resolved '.commit-sha'
  Assert-EunsungOrdinaryFile -Path $shaMarkerPath -AttributeProvider $AttributeProvider
  $releaseSha = (Get-Content -Raw -LiteralPath $shaMarkerPath).Trim()
  if ($releaseSha -cne $CommitSha) { throw 'Release marker does not exactly match CommitSha' }
  $markerPath = Join-Path $resolved 'build.complete.json'
  Assert-EunsungOrdinaryFile -Path $markerPath -AttributeProvider $AttributeProvider
  try { $marker = Get-Content -Raw -LiteralPath $markerPath | ConvertFrom-Json } catch { throw 'Build marker is invalid JSON' }
  if ([string]$marker.commitSha -cne $CommitSha) { throw 'Build marker SHA does not exactly match CommitSha' }
  foreach ($relativePath in $script:ExpectedOutputs) {
    if (-not (@($marker.expectedOutputs) -ccontains $relativePath)) { throw "Build marker is missing expected output: $relativePath" }
    Assert-EunsungOrdinaryFile -Path (Join-Path $resolved $relativePath) -AttributeProvider $AttributeProvider
  }
  $actualHashes = Get-EunsungConfigHashes -ReleaseDir $resolved
  foreach ($relativePath in $script:NonSecretConfigFiles) {
    $recorded = [string]$marker.configHashes.$relativePath
    if ($recorded -cne [string]$actualHashes[$relativePath]) { throw "Deployment config hash mismatch: $relativePath" }
  }
  Assert-EunsungProtectedConfig -ReleaseDir $resolved -AccessValidator $AccessValidator -AttributeProvider $AttributeProvider
}

function Remove-EunsungOldSuccessfulReleases {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$ReleaseRoot,
    [Parameter(Mandatory)][string]$CurrentRelease,
    [ValidateRange(0, 20)][int]$PriorSuccessesToKeep = 2,
    [scriptblock]$AttributeProvider
  )
  if (-not (Test-Path -LiteralPath $ReleaseRoot)) { return }
  $releaseRootFull = (Resolve-Path -LiteralPath $ReleaseRoot).ProviderPath
  $currentFull = Resolve-EunsungContainedPath -Root $releaseRootFull -Candidate $CurrentRelease
  $prior = New-Object System.Collections.Generic.List[object]
  foreach ($release in @(Get-ChildItem -LiteralPath $releaseRootFull -Directory)) {
    if (-not (Test-EunsungCommitSha $release.Name) -or $release.FullName -eq $currentFull) { continue }
    try {
      Assert-EunsungNoReparseAncestry -Root $releaseRootFull -Target $release.FullName -AttributeProvider $AttributeProvider
      $markerPath = Join-Path $release.FullName 'deployment.success.json'
      Assert-EunsungOrdinaryFile -Path $markerPath -AttributeProvider $AttributeProvider
      $marker = Get-Content -Raw -LiteralPath $markerPath | ConvertFrom-Json
      if ([string]$marker.commitSha -cne $release.Name) { continue }
      $releaseDirProperty = $marker.PSObject.Properties['releaseDir']
      if ($null -ne $releaseDirProperty -and -not [string]::IsNullOrWhiteSpace([string]$releaseDirProperty.Value) -and (Resolve-EunsungContainedPath -Root $releaseRootFull -Candidate ([string]$releaseDirProperty.Value)) -cne $release.FullName) { continue }
      [void]$prior.Add($release)
    } catch { continue }
  }
  $prior = @($prior | Sort-Object LastWriteTimeUtc -Descending)
  @($prior | Select-Object -Skip $PriorSuccessesToKeep) | ForEach-Object {
    Assert-EunsungNoReparseAncestry -Root $releaseRootFull -Target $_.FullName -AttributeProvider $AttributeProvider
    $markerPath = Join-Path $_.FullName 'deployment.success.json'
    Assert-EunsungOrdinaryFile -Path $markerPath -AttributeProvider $AttributeProvider
    $marker = Get-Content -Raw -LiteralPath $markerPath | ConvertFrom-Json
    if ([string]$marker.commitSha -cne $_.Name) { throw 'Successful release marker changed before retention' }
    Remove-Item -LiteralPath $_.FullName -Recurse -Force
  }
}

function Assert-EunsungDeploymentMode {
  [CmdletBinding()]
  param(
    [string]$ArchivePath,
    [switch]$BuildOnly,
    [switch]$ActivateExisting,
    [switch]$InjectHealthFailure,
    [switch]$AllowFailureInjection
  )
  if ($BuildOnly -and $ActivateExisting) { throw 'BuildOnly and ActivateExisting are mutually exclusive' }
  if ($ActivateExisting -and -not [string]::IsNullOrWhiteSpace($ArchivePath)) { throw 'ActivateExisting does not accept an archive' }
  if ($InjectHealthFailure -and -not $ActivateExisting) { throw 'InjectHealthFailure requires ActivateExisting' }
  if ($InjectHealthFailure -and -not $AllowFailureInjection) { throw 'InjectHealthFailure requires AllowFailureInjection' }
  if ($AllowFailureInjection -and -not $InjectHealthFailure) { throw 'AllowFailureInjection requires InjectHealthFailure' }
  if (-not $ActivateExisting -and [string]::IsNullOrWhiteSpace($ArchivePath)) { throw 'ArchivePath is required for a new release' }
}

function Get-EunsungAdapter {
  param([hashtable]$Adapters, [string]$Name, [scriptblock]$Default)
  if ($Adapters -and $Adapters.ContainsKey($Name)) { return [scriptblock]$Adapters[$Name] }
  return $Default
}

function Test-EunsungRecoveryAccess {
  param([string]$Path, [scriptblock]$AccessValidator)
  if ($AccessValidator) { return [bool](& $AccessValidator $Path) }
  return Test-EunsungAclAccess -Path $Path
}

function Assert-EunsungRecoveryStorage {
  param(
    [string]$DeployRoot,
    [string]$Pm2Home,
    [string]$StateDir,
    [string]$DumpPath,
    [scriptblock]$AttributeProvider,
    [scriptblock]$AccessValidator
  )

  Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $StateDir -AttributeProvider $AttributeProvider
  $resolvedState = Resolve-EunsungContainedPath -Root $DeployRoot -Candidate $StateDir -AllowMissing
  Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $DeployRoot -AttributeProvider $AttributeProvider
  if (Test-Path -LiteralPath $resolvedState) {
    Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $resolvedState -AttributeProvider $AttributeProvider
    if (-not (Test-EunsungRecoveryAccess -Path $resolvedState -AccessValidator $AccessValidator)) { throw 'Recovery state directory ACL validation failed' }
  }
  if (-not [IO.Directory]::Exists($Pm2Home)) { throw 'PM2_HOME directory is unavailable' }
  Assert-EunsungNoReparsePath -Path $Pm2Home -AttributeProvider $AttributeProvider
  if (-not (Test-EunsungRecoveryAccess -Path $Pm2Home -AccessValidator $AccessValidator)) { throw 'PM2_HOME ACL validation failed' }
  Assert-EunsungNoReparsePath -Path $DumpPath -AttributeProvider $AttributeProvider
  Assert-EunsungOrdinaryFile -Path $DumpPath -AttributeProvider $AttributeProvider
  if (-not (Test-EunsungRecoveryAccess -Path $DumpPath -AccessValidator $AccessValidator)) { throw 'PM2 dump ACL validation failed' }
  return $resolvedState
}

function Set-EunsungRecoveryBackupAcl {
  param([string]$Path, [scriptblock]$AclSetter)
  if ($AclSetter) { & $AclSetter $Path; return }
  $deploySidValue = Resolve-EunsungIdentitySid -Identity 'eunsung-deploy'
  $deploySid = New-Object -TypeName Security.Principal.SecurityIdentifier -ArgumentList $deploySidValue
  $acl = Get-Acl -LiteralPath $Path
  $acl.SetAccessRuleProtection($true, $false)
  foreach ($existingRule in @($acl.Access)) { [void]$acl.RemoveAccessRuleAll($existingRule) }
  $acl.SetOwner($deploySid)
  $rule = New-Object -TypeName Security.AccessControl.FileSystemAccessRule -ArgumentList @($deploySid, [Security.AccessControl.FileSystemRights]::FullControl, [Security.AccessControl.AccessControlType]::Allow)
  $acl.AddAccessRule($rule)
  Set-Acl -LiteralPath $Path -AclObject $acl
}

function Remove-EunsungStaleRecoveryDumps {
  param(
    [string]$DeployRoot,
    [string]$StateDir,
    [ValidateRange(0, 5)][int]$Keep = 0,
    [scriptblock]$AttributeProvider,
    [scriptblock]$AccessValidator
  )
  if (-not (Test-Path -LiteralPath $StateDir -PathType Container)) { return }
  Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $StateDir -AttributeProvider $AttributeProvider
  $resolvedState = Resolve-EunsungContainedPath -Root $DeployRoot -Candidate $StateDir
  Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $resolvedState -AttributeProvider $AttributeProvider
  if (-not (Test-EunsungRecoveryAccess -Path $resolvedState -AccessValidator $AccessValidator)) { throw 'Recovery state directory ACL validation failed' }
  $candidates = New-Object System.Collections.Generic.List[object]
  foreach ($item in @(Get-ChildItem -LiteralPath $resolvedState -Force -File)) {
    if ($item.Name -cnotmatch '^dump-before-[0-9a-f]{32}\.pm2$') { continue }
    try {
      $resolvedItem = Resolve-EunsungContainedPath -Root $resolvedState -Candidate $item.FullName
      Assert-EunsungNoReparseAncestry -Root $resolvedState -Target $resolvedItem -AttributeProvider $AttributeProvider
      Assert-EunsungOrdinaryFile -Path $resolvedItem -AttributeProvider $AttributeProvider
      if (-not (Test-EunsungRecoveryAccess -Path $resolvedItem -AccessValidator $AccessValidator)) { continue }
      [void]$candidates.Add($item)
    } catch { continue }
  }
  $ordered = @($candidates | Sort-Object LastWriteTimeUtc -Descending)
  foreach ($candidate in @($ordered | Select-Object -Skip $Keep)) {
    $resolvedItem = Resolve-EunsungContainedPath -Root $resolvedState -Candidate $candidate.FullName
    Assert-EunsungNoReparseAncestry -Root $resolvedState -Target $resolvedItem -AttributeProvider $AttributeProvider
    Assert-EunsungOrdinaryFile -Path $resolvedItem -AttributeProvider $AttributeProvider
    if (-not (Test-EunsungRecoveryAccess -Path $resolvedItem -AccessValidator $AccessValidator)) { continue }
    Remove-Item -LiteralPath $resolvedItem -Force
  }
}

function Get-EunsungSwitchState {
  param(
    [string]$DeployRoot,
    [scriptblock]$NativeInvoker,
    [scriptblock]$AttributeProvider,
    [scriptblock]$AccessValidator,
    [scriptblock]$AclSetter
  )
  $currentPath = Join-Path $DeployRoot 'current.json'
  $current = $null
  if (Test-Path -LiteralPath $currentPath -PathType Leaf) {
    try { $current = Get-Content -Raw -LiteralPath $currentPath | ConvertFrom-Json } catch { throw 'Current release marker is invalid' }
  }
  $apps = ConvertFrom-EunsungPm2Json -Json (Invoke-EunsungNative -FilePath 'pm2.cmd' -Arguments @('jlist') -NativeInvoker $NativeInvoker)
  $capturedApps = @($apps | Where-Object { $script:AppPorts.Contains($_.name) })
  $pm2Home = [Environment]::GetEnvironmentVariable('PM2_HOME', 'Process')
  if ([string]::IsNullOrWhiteSpace($pm2Home)) { $pm2Home = Join-Path $env:USERPROFILE '.pm2' }
  $pm2Home = [IO.Path]::GetFullPath($pm2Home)
  $dumpPath = Join-Path $pm2Home 'dump.pm2'
  $backup = $null
  $backupHash = $null
  $originalDumpExists = Test-Path -LiteralPath $dumpPath -PathType Leaf
  if ($originalDumpExists) {
    $stateDir = Join-Path $DeployRoot 'state'
    Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $stateDir -AttributeProvider $AttributeProvider
    $stateDir = Resolve-EunsungContainedPath -Root $DeployRoot -Candidate $stateDir -AllowMissing
    New-Item -ItemType Directory -Force -Path $stateDir | Out-Null
    $stateDir = Assert-EunsungRecoveryStorage -DeployRoot $DeployRoot -Pm2Home $pm2Home -StateDir $stateDir -DumpPath $dumpPath -AttributeProvider $AttributeProvider -AccessValidator $AccessValidator
    Remove-EunsungStaleRecoveryDumps -DeployRoot $DeployRoot -StateDir $stateDir -Keep 0 -AttributeProvider $AttributeProvider -AccessValidator $AccessValidator
    $backup = Join-Path $stateDir ("dump-before-$([guid]::NewGuid().ToString('N')).pm2")
    Copy-Item -LiteralPath $dumpPath -Destination $backup
    Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $backup -AttributeProvider $AttributeProvider
    Assert-EunsungOrdinaryFile -Path $backup -AttributeProvider $AttributeProvider
    Set-EunsungRecoveryBackupAcl -Path $backup -AclSetter $AclSetter
    Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $backup -AttributeProvider $AttributeProvider
    Assert-EunsungOrdinaryFile -Path $backup -AttributeProvider $AttributeProvider
    if (-not (Test-EunsungRecoveryAccess -Path $backup -AccessValidator $AccessValidator)) { throw 'Recovery dump backup ACL validation failed' }
    $backupHash = Get-EunsungFileSha256 -Path $backup
    if ((Get-EunsungFileSha256 -Path $dumpPath) -cne $backupHash) { throw 'PM2 dump backup copy validation failed' }
  }
  return @{
    HasPrior = ($null -ne $current)
    CurrentMarker = $current
    Apps = $capturedApps
    DumpBackup = $backup
    DumpBackupHash = $backupHash
    DumpPath = $dumpPath
    OriginalDumpExists = $originalDumpExists
  }
}

function Start-EunsungApps {
  param([string]$ReleaseDir, [string]$DeployRoot, [scriptblock]$NativeInvoker)
  $oracleClientLibDir = [Environment]::GetEnvironmentVariable('ORACLE_CLIENT_LIB_DIR', 'Process')
  if ([string]::IsNullOrWhiteSpace($oracleClientLibDir)) { throw 'ORACLE_CLIENT_LIB_DIR is required' }
  $environment = @{
    EUNSUNG_RELEASE_DIR = $ReleaseDir
    EUNSUNG_DEPLOY_ROOT = $DeployRoot
    ORACLE_CLIENT_LIB_DIR = $oracleClientLibDir
  }
  Invoke-EunsungNative -FilePath 'pm2.cmd' -Arguments @('start', (Join-Path $ReleaseDir 'ecosystem.config.js'), '--only', 'eunsung-frontend,eunsung-backend', '--update-env') -Environment $environment -NativeInvoker $NativeInvoker | Out-Null
}

function Stop-EunsungNewApps {
  param([scriptblock]$NativeInvoker)
  $failures = New-Object System.Collections.Generic.List[string]
  foreach ($name in $script:AppPorts.Keys) {
    try {
      Invoke-EunsungNative -FilePath 'pm2.cmd' -Arguments @('delete', $name) -NativeInvoker $NativeInvoker | Out-Null
    } catch {
      $failures.Add("$name`: $(ConvertTo-EunsungSanitizedDiagnostic $_.Exception.Message)")
    }
  }
  if ($failures.Count -gt 0) { throw "PM2 cleanup failed. $($failures -join '; ')" }
}

function Get-EunsungObjectMember {
  param([AllowNull()][object]$Object, [Parameter(Mandatory)][string]$Name)
  if ($null -eq $Object) { return @{ Present = $false; Value = $null } }
  if ($Object -is [Collections.IDictionary]) {
    if ($Object.Contains($Name)) { return @{ Present = $true; Value = $Object[$Name] } }
    return @{ Present = $false; Value = $null }
  }
  $property = $Object.PSObject.Properties[$Name]
  if ($null -eq $property) { return @{ Present = $false; Value = $null } }
  return @{ Present = $true; Value = $property.Value }
}

function Assert-EunsungPm2DefinitionFidelity {
  param([object[]]$CapturedApps, [object[]]$RestoredApps)
  if (@($CapturedApps).Count -ne $script:AppPorts.Count) { throw 'Captured prior PM2 definitions are incomplete' }
  foreach ($captured in @($CapturedApps)) {
    $name = [string]$captured.name
    if (-not $script:AppPorts.Contains($name) -or [int]$captured.pid -le 0) { throw 'Captured prior PM2 app identity or PID is invalid' }
    $matches = @($RestoredApps | Where-Object { [string]$_.name -ceq $name })
    if ($matches.Count -ne 1) { throw "Restored PM2 app is missing or duplicated: $name" }
    $expectedPm = Get-EunsungObjectMember -Object $captured -Name 'pm2_env'
    $actualPm = Get-EunsungObjectMember -Object $matches[0] -Name 'pm2_env'
    if (-not $expectedPm.Present -or -not $actualPm.Present) { throw "PM2 definition is incomplete: $name" }
    foreach ($option in @('pm_exec_path', 'pm_cwd', 'args', 'exec_interpreter', 'pm_out_log_path', 'pm_err_log_path', 'out_file', 'error_file', 'instances', 'exec_mode', 'autorestart', 'watch', 'min_uptime', 'max_restarts', 'restart_delay', 'exp_backoff_restart_delay', 'kill_timeout', 'merge_logs', 'log_date_format', 'max_memory_restart', 'env')) {
      $expected = Get-EunsungObjectMember -Object $expectedPm.Value -Name $option
      if (-not $expected.Present) { continue }
      $actual = Get-EunsungObjectMember -Object $actualPm.Value -Name $option
      if (-not $actual.Present) { throw "Restored PM2 option is missing: $name/$option" }
      $expectedJson = ConvertTo-Json -InputObject $expected.Value -Depth 12 -Compress
      $actualJson = ConvertTo-Json -InputObject $actual.Value -Depth 12 -Compress
      if ($expectedJson -cne $actualJson) { throw "Restored PM2 option mismatch: $name/$option" }
    }
  }
}

function Assert-EunsungRecoveryDumpBackup {
  param(
    [string]$DeployRoot,
    [string]$BackupPath,
    [string]$DumpPath,
    [scriptblock]$AttributeProvider,
    [scriptblock]$AccessValidator
  )
  if ([string]::IsNullOrWhiteSpace($DeployRoot)) { return }
  $stateDir = Join-Path $DeployRoot 'state'
  Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $stateDir -AttributeProvider $AttributeProvider
  $resolvedState = Resolve-EunsungContainedPath -Root $DeployRoot -Candidate $stateDir
  $resolvedBackup = Resolve-EunsungContainedPath -Root $resolvedState -Candidate $BackupPath
  if ((Split-Path -Leaf $resolvedBackup) -cnotmatch '^dump-before-[0-9a-f]{32}\.pm2$') { throw 'Recovery dump backup name is invalid' }
  Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $resolvedBackup -AttributeProvider $AttributeProvider
  Assert-EunsungOrdinaryFile -Path $resolvedBackup -AttributeProvider $AttributeProvider
  if (-not (Test-EunsungRecoveryAccess -Path $resolvedState -AccessValidator $AccessValidator)) { throw 'Recovery state directory ACL validation failed' }
  if (-not (Test-EunsungRecoveryAccess -Path $resolvedBackup -AccessValidator $AccessValidator)) { throw 'Recovery dump backup ACL validation failed' }
  $pm2Home = Split-Path -Parent $DumpPath
  if (-not [IO.Directory]::Exists($pm2Home)) { throw 'PM2 dump directory is unavailable' }
  Assert-EunsungNoReparsePath -Path $pm2Home -AttributeProvider $AttributeProvider
  if (-not (Test-EunsungRecoveryAccess -Path $pm2Home -AccessValidator $AccessValidator)) { throw 'PM2_HOME ACL validation failed' }
  if (Test-Path -LiteralPath $DumpPath) {
    Assert-EunsungNoReparsePath -Path $DumpPath -AttributeProvider $AttributeProvider
    Assert-EunsungOrdinaryFile -Path $DumpPath -AttributeProvider $AttributeProvider
    if (-not (Test-EunsungRecoveryAccess -Path $DumpPath -AccessValidator $AccessValidator)) { throw 'PM2 dump ACL validation failed' }
  }
}

function Restore-EunsungPriorState {
  param([hashtable]$SwitchState, [scriptblock]$NativeInvoker, [string]$DeployRoot, [scriptblock]$AttributeProvider, [scriptblock]$AccessValidator)
  $captured = @($SwitchState.Apps)
  $dumpBackup = [string]$SwitchState.DumpBackup
  $dumpPath = [string]$SwitchState.DumpPath
  if ([string]::IsNullOrWhiteSpace($dumpBackup) -or [string]::IsNullOrWhiteSpace($dumpPath)) { throw 'Prior PM2 dump backup is unavailable' }
  Assert-EunsungRecoveryDumpBackup -DeployRoot $DeployRoot -BackupPath $dumpBackup -DumpPath $dumpPath -AttributeProvider $AttributeProvider -AccessValidator $AccessValidator
  Assert-EunsungOrdinaryFile -Path $dumpBackup
  $dumpParent = Split-Path -Parent $dumpPath
  if (-not [IO.Directory]::Exists($dumpParent)) { throw 'PM2 dump directory is unavailable' }
  if (Test-Path -LiteralPath $dumpPath) { Assert-EunsungOrdinaryFile -Path $dumpPath }
  $backupHash = Get-EunsungFileSha256 -Path $dumpBackup
  Copy-Item -LiteralPath $dumpBackup -Destination $dumpPath -Force
  Assert-EunsungOrdinaryFile -Path $dumpPath
  if ($backupHash -cne (Get-EunsungFileSha256 -Path $dumpPath)) { throw 'PM2 dump backup copy validation failed' }
  Invoke-EunsungNative -FilePath 'pm2.cmd' -Arguments @('resurrect') -NativeInvoker $NativeInvoker | Out-Null
  $restored = ConvertFrom-EunsungPm2Json -Json (Invoke-EunsungNative -FilePath 'pm2.cmd' -Arguments @('jlist') -NativeInvoker $NativeInvoker)
  Assert-EunsungPm2DefinitionFidelity -CapturedApps $captured -RestoredApps $restored
  foreach ($name in $script:AppPorts.Keys) {
    Invoke-EunsungNative -FilePath 'pm2.cmd' -Arguments @('describe', $name) -NativeInvoker $NativeInvoker | Out-Null
  }
}

function Assert-EunsungRollbackSnapshot {
  param([string]$DeployRoot, [hashtable]$SwitchState, [scriptblock]$AccessValidator)
  if (-not $SwitchState.HasPrior) { return }
  if ($null -eq $SwitchState.CurrentMarker) { throw 'Prior release marker is unavailable' }
  $priorSha = [string]$SwitchState.CurrentMarker.commitSha
  $priorRelease = [string]$SwitchState.CurrentMarker.releaseDir
  Assert-EunsungBuiltRelease -DeployRoot $DeployRoot -ReleaseDir $priorRelease -CommitSha $priorSha -AccessValidator $AccessValidator
  $captured = @($SwitchState.Apps)
  Assert-EunsungPm2DefinitionFidelity -CapturedApps $captured -RestoredApps $captured
  $priorFull = (Resolve-Path -LiteralPath $priorRelease).ProviderPath.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
  foreach ($app in $captured) {
    $name = [string]$app.name
    $appSubdir = if ($name -ceq 'eunsung-frontend') { 'apps/frontend' } else { 'apps/backend' }
    $expectedCwd = Join-Path $priorFull $appSubdir
    $actualCwd = [IO.Path]::GetFullPath([string]$app.pm2_env.pm_cwd).TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
    $actualExec = [IO.Path]::GetFullPath([string]$app.pm2_env.pm_exec_path)
    if ($actualCwd -cne $expectedCwd -or -not $actualExec.StartsWith($expectedCwd + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw "Captured prior PM2 path does not match prior release: $name" }
  }
  $dumpBackup = [string]$SwitchState.DumpBackup
  if ([string]::IsNullOrWhiteSpace($dumpBackup)) { throw 'Prior PM2 dump backup is unavailable' }
  Assert-EunsungOrdinaryFile -Path $dumpBackup
  if (-not [string]::IsNullOrWhiteSpace([string]$SwitchState.DumpBackupHash) -and ([string]$SwitchState.DumpBackupHash -cne (Get-EunsungFileSha256 -Path $dumpBackup))) { throw 'Prior PM2 dump backup hash mismatch' }
}

function Remove-EunsungRecoveryDump {
  param([hashtable]$SwitchState, [string]$DeployRoot, [scriptblock]$AttributeProvider, [scriptblock]$AccessValidator)
  $backup = [string]$SwitchState.DumpBackup
  if ([string]::IsNullOrWhiteSpace($backup) -or -not (Test-Path -LiteralPath $backup)) { return }
  $dumpPath = if ($SwitchState.ContainsKey('DumpPath')) { [string]$SwitchState.DumpPath } else { '' }
  if (-not [string]::IsNullOrWhiteSpace($DeployRoot)) {
    if ([string]::IsNullOrWhiteSpace($dumpPath)) { throw 'Recovery dump path is unavailable' }
    Assert-EunsungRecoveryDumpBackup -DeployRoot $DeployRoot -BackupPath $backup -DumpPath $dumpPath -AttributeProvider $AttributeProvider -AccessValidator $AccessValidator
  }
  Assert-EunsungOrdinaryFile -Path $backup
  Remove-Item -LiteralPath $backup -Force
}

function Restore-EunsungOriginalDump {
  param([hashtable]$SwitchState, [string]$DeployRoot, [scriptblock]$AttributeProvider, [scriptblock]$AccessValidator)
  $originalDumpExists = $SwitchState.ContainsKey('OriginalDumpExists') -and [bool]$SwitchState.OriginalDumpExists
  $dumpPath = if ($SwitchState.ContainsKey('DumpPath')) { [string]$SwitchState.DumpPath } else { '' }
  if ($originalDumpExists) {
    $backup = [string]$SwitchState.DumpBackup
    $destination = $dumpPath
    Assert-EunsungRecoveryDumpBackup -DeployRoot $DeployRoot -BackupPath $backup -DumpPath $destination -AttributeProvider $AttributeProvider -AccessValidator $AccessValidator
    Assert-EunsungOrdinaryFile -Path $backup
    Copy-Item -LiteralPath $backup -Destination $destination -Force
    Assert-EunsungOrdinaryFile -Path $destination
    if ((Get-EunsungFileSha256 -Path $backup) -cne (Get-EunsungFileSha256 -Path $destination)) { throw 'Original PM2 dump restoration validation failed' }
  } elseif (-not [string]::IsNullOrWhiteSpace($dumpPath) -and (Test-Path -LiteralPath $dumpPath -PathType Leaf)) {
    Assert-EunsungOrdinaryFile -Path $dumpPath
    Remove-Item -LiteralPath $dumpPath -Force
  }
}

function Set-EunsungCurrentMarker {
  param([string]$DeployRoot, [AllowNull()][object]$Marker)
  $currentPath = Join-Path $DeployRoot 'current.json'
  if ($null -eq $Marker) {
    if (Test-Path -LiteralPath $currentPath) { Remove-Item -LiteralPath $currentPath -Force }
    return
  }
  Write-EunsungJsonAtomic -Path $currentPath -Value $Marker
}

function New-EunsungFailureException {
  param([string]$Message, [int]$ExitCode)
  $exception = New-Object System.Exception($Message)
  $exception.Data['ExitCode'] = $ExitCode
  return $exception
}

function Invoke-EunsungActivation {
  param(
    [string]$DeployRoot,
    [string]$ReleaseDir,
    [string]$CommitSha,
    [switch]$InjectHealthFailure,
    [hashtable]$Adapters
  )

  $native = Get-EunsungAdapter -Adapters $Adapters -Name 'NativeInvoker' -Default $null
  $pm2ListProvider = Get-EunsungAdapter -Adapters $Adapters -Name 'Pm2ListProvider' -Default $null
  $portOwnerProvider = Get-EunsungAdapter -Adapters $Adapters -Name 'PortOwnerProvider' -Default $null
  $httpInvoker = Get-EunsungAdapter -Adapters $Adapters -Name 'HttpInvoker' -Default $null
  $sleepAdapter = Get-EunsungAdapter -Adapters $Adapters -Name 'SleepAdapter' -Default $null
  $accessValidator = Get-EunsungAdapter -Adapters $Adapters -Name 'AccessValidator' -Default $null
  $attributeProvider = Get-EunsungAdapter -Adapters $Adapters -Name 'AttributeProvider' -Default $null
  $aclSetter = Get-EunsungAdapter -Adapters $Adapters -Name 'AclSetter' -Default $null
  $capture = Get-EunsungAdapter -Adapters $Adapters -Name 'CaptureSwitchState' -Default { param($Root) Get-EunsungSwitchState -DeployRoot $Root -NativeInvoker $native -AttributeProvider $attributeProvider -AccessValidator $accessValidator -AclSetter $aclSetter }
  $switch = Get-EunsungAdapter -Adapters $Adapters -Name 'SwitchApps' -Default { param($Release, $Root) Start-EunsungApps -ReleaseDir $Release -DeployRoot $Root -NativeInvoker $native }
  $stopNew = Get-EunsungAdapter -Adapters $Adapters -Name 'StopNewApps' -Default { Stop-EunsungNewApps -NativeInvoker $native }
  $restore = Get-EunsungAdapter -Adapters $Adapters -Name 'RestorePrior' -Default { param($State) Restore-EunsungPriorState -SwitchState $State -NativeInvoker $native -DeployRoot $DeployRoot -AttributeProvider $attributeProvider -AccessValidator $accessValidator }
  $save = Get-EunsungAdapter -Adapters $Adapters -Name 'SaveState' -Default { Invoke-EunsungNative -FilePath 'pm2.cmd' -Arguments @('save') -NativeInvoker $native | Out-Null }
  $health = Get-EunsungAdapter -Adapters $Adapters -Name 'HealthCheck' -Default {
    param($Expected, $Release)
    $markerSha = (Get-Content -Raw -LiteralPath (Join-Path $Release '.commit-sha')).Trim()
    Test-EunsungReleaseHealth -ExpectedSha $Expected -ReleaseMarkerSha $markerSha -ExpectedReleaseDir $Release -Pm2ListProvider $pm2ListProvider -PortOwnerProvider $portOwnerProvider -HttpInvoker $httpInvoker -SleepAdapter $sleepAdapter
  }
  $rollbackHealth = Get-EunsungAdapter -Adapters $Adapters -Name 'RollbackHealthCheck' -Default {
    param($State)
    if ($null -eq $State.CurrentMarker) { return @{ Success = $false; Diagnostics = @('prior marker unavailable') } }
    $markerSha = (Get-Content -Raw -LiteralPath (Join-Path ([string]$State.CurrentMarker.releaseDir) '.commit-sha')).Trim()
    Test-EunsungReleaseHealth -ExpectedSha ([string]$State.CurrentMarker.commitSha) -ReleaseMarkerSha $markerSha -ExpectedReleaseDir ([string]$State.CurrentMarker.releaseDir) -Pm2ListProvider $pm2ListProvider -PortOwnerProvider $portOwnerProvider -HttpInvoker $httpInvoker -SleepAdapter $sleepAdapter
  }
  $retention = Get-EunsungAdapter -Adapters $Adapters -Name 'Retention' -Default { param($Root, $Current) Remove-EunsungOldSuccessfulReleases -ReleaseRoot $Root -CurrentRelease $Current -PriorSuccessesToKeep 2 }
  $preflight = Get-EunsungAdapter -Adapters $Adapters -Name 'PreflightSnapshot' -Default { param($State) Assert-EunsungRollbackSnapshot -DeployRoot $DeployRoot -SwitchState $State -AccessValidator $accessValidator }

  $switchState = & $capture $DeployRoot
  & $preflight $switchState
  $failure = $null
  try {
    & $switch $ReleaseDir $DeployRoot
    if ($InjectHealthFailure) {
      $healthResult = @{ Success = $false; Diagnostics = @('injected post-switch health failure') }
    } else {
      $healthResult = & $health $CommitSha $ReleaseDir
    }
    if (-not $healthResult.Success) {
      throw (($healthResult.Diagnostics | ForEach-Object { ConvertTo-EunsungSanitizedDiagnostic $_ }) -join '; ')
    }

    & $save
    $currentMarker = [ordered]@{ commitSha = $CommitSha; releaseDir = $ReleaseDir; activatedAtUtc = [DateTime]::UtcNow.ToString('o') }
    Set-EunsungCurrentMarker -DeployRoot $DeployRoot -Marker $currentMarker
    Write-EunsungJsonAtomic -Path (Join-Path $ReleaseDir 'deployment.success.json') -Value $currentMarker
    Remove-EunsungRecoveryDump -SwitchState $switchState -DeployRoot $DeployRoot -AttributeProvider $attributeProvider -AccessValidator $accessValidator
    try { & $retention (Join-Path $DeployRoot 'releases') $ReleaseDir } catch { Write-Warning 'Post-commit release retention failed' }
    return
  } catch {
    $failure = ConvertTo-EunsungSanitizedDiagnostic $_.Exception.Message
  }

  $cleanupFailure = $null
  try { & $stopNew } catch { $cleanupFailure = ConvertTo-EunsungSanitizedDiagnostic $_.Exception.Message }
  if (-not $switchState.HasPrior) {
    Restore-EunsungOriginalDump -SwitchState $switchState -DeployRoot $DeployRoot -AttributeProvider $attributeProvider -AccessValidator $accessValidator
    Set-EunsungCurrentMarker -DeployRoot $DeployRoot -Marker $null
    Remove-EunsungRecoveryDump -SwitchState $switchState -DeployRoot $DeployRoot -AttributeProvider $attributeProvider -AccessValidator $accessValidator
    if ($cleanupFailure) { throw (New-EunsungFailureException -Message "Deployment failed with no prior release and cleanup failed. new=[$failure] cleanup=[$cleanupFailure]" -ExitCode 31) }
    throw (New-EunsungFailureException -Message "Deployment failed with no prior release; new apps stopped. $failure" -ExitCode 30)
  }

  try {
    & $restore $switchState
    $restoredHealth = & $rollbackHealth $switchState
    if (-not $restoredHealth.Success) {
      $safeRollback = ($restoredHealth.Diagnostics | ForEach-Object { ConvertTo-EunsungSanitizedDiagnostic $_ }) -join '; '
      throw "rollback health failed. $safeRollback"
    }
    & $save
    Set-EunsungCurrentMarker -DeployRoot $DeployRoot -Marker $switchState.CurrentMarker
    if (Test-Path -LiteralPath (Join-Path $ReleaseDir 'deployment.success.json')) { Remove-Item -LiteralPath (Join-Path $ReleaseDir 'deployment.success.json') -Force }
    Remove-EunsungRecoveryDump -SwitchState $switchState -DeployRoot $DeployRoot -AttributeProvider $attributeProvider -AccessValidator $accessValidator
    if ($cleanupFailure) { throw "new-app cleanup failed. $cleanupFailure" }
  } catch {
    $safeRollbackFailure = ConvertTo-EunsungSanitizedDiagnostic $_.Exception.Message
    throw (New-EunsungFailureException -Message "Deployment failed and rollback health failed. new=[$failure] rollback=[$safeRollbackFailure]" -ExitCode 31)
  }
  throw (New-EunsungFailureException -Message "Deployment failed and was rolled back. $failure" -ExitCode 30)
}

function Copy-EunsungProtectedConfigs {
  param([string]$DeployRoot, [string]$ReleaseDir, [scriptblock]$AccessValidator, [scriptblock]$AttributeProvider)
  $mappings = @(
    @{ Source = Join-Path (Join-Path $DeployRoot 'shared') 'backend.env'; Destination = Join-Path $ReleaseDir 'apps/backend/.env' },
    @{ Source = Join-Path (Join-Path $DeployRoot 'shared') 'frontend-database.json'; Destination = Join-Path $ReleaseDir 'apps/frontend/config/database.json' }
  )
  foreach ($mapping in $mappings) {
    Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $mapping.Source -AttributeProvider $AttributeProvider
    Assert-EunsungOrdinaryFile -Path $mapping.Source -AttributeProvider $AttributeProvider
    if ($AccessValidator) { $accessAllowed = & $AccessValidator $mapping.Source } else { $accessAllowed = Test-EunsungAclAccess -Path $mapping.Source }
    if (-not $accessAllowed) { throw 'Protected shared file ACL or access validation failed' }
    $parent = Split-Path -Parent $mapping.Destination
    if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    Copy-Item -LiteralPath $mapping.Source -Destination $mapping.Destination
    Assert-EunsungNoReparseAncestry -Root $ReleaseDir -Target $mapping.Destination -AttributeProvider $AttributeProvider
    Assert-EunsungOrdinaryFile -Path $mapping.Destination -AttributeProvider $AttributeProvider
  }
}

function Invoke-EunsungBuild {
  param([string]$ReleaseDir, [string]$CommitSha, [scriptblock]$NativeInvoker)
  $versionOutput = Invoke-EunsungNative -FilePath 'corepack.cmd' -Arguments @('pnpm@10.28.1', '--version') -WorkingDirectory $ReleaseDir -NativeInvoker $NativeInvoker
  if ($versionOutput.Trim() -cne '10.28.1') { throw 'Explicit pnpm version 10.28.1 was not selected' }
  Invoke-EunsungNative -FilePath 'corepack.cmd' -Arguments @('pnpm@10.28.1', 'install', '--frozen-lockfile') -WorkingDirectory $ReleaseDir -NativeInvoker $NativeInvoker | Out-Null
  Invoke-EunsungNative -FilePath 'corepack.cmd' -Arguments @('pnpm@10.28.1', '--filter', '@smt/shared', 'build') -WorkingDirectory $ReleaseDir -NativeInvoker $NativeInvoker | Out-Null
  Invoke-EunsungNative -FilePath 'corepack.cmd' -Arguments @('pnpm@10.28.1', '--filter', '@eunsung/backend', 'build') -WorkingDirectory $ReleaseDir -NativeInvoker $NativeInvoker | Out-Null
  Invoke-EunsungNative -FilePath 'corepack.cmd' -Arguments @('pnpm@10.28.1', '--filter', '@eunsung/frontend', 'build') -WorkingDirectory $ReleaseDir -NativeInvoker $NativeInvoker | Out-Null
  Write-EunsungBuildMarker -ReleaseDir $ReleaseDir -CommitSha $CommitSha
}

function Invoke-EunsungDeployment {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$CommitSha,
    [string]$ArchivePath,
    [switch]$BuildOnly,
    [switch]$ActivateExisting,
    [switch]$InjectHealthFailure,
    [switch]$AllowFailureInjection,
    [string]$DeployRoot = $script:DefaultDeployRoot,
    [hashtable]$Adapters
  )

  if (-not (Test-EunsungCommitSha $CommitSha)) { throw 'CommitSha must be exactly 40 lowercase hexadecimal characters' }
  Assert-EunsungDeploymentMode -ArchivePath $ArchivePath -BuildOnly:$BuildOnly -ActivateExisting:$ActivateExisting -InjectHealthFailure:$InjectHealthFailure -AllowFailureInjection:$AllowFailureInjection
  if ($DeployRoot -ne $script:DefaultDeployRoot -and (-not $Adapters -or -not $Adapters.ContainsKey('TestMode') -or -not $Adapters.TestMode)) {
    throw 'A custom DeployRoot is allowed only with injected test adapters'
  }

  if (-not (Test-Path -LiteralPath $DeployRoot)) { New-Item -ItemType Directory -Force -Path $DeployRoot | Out-Null }
  $DeployRoot = Resolve-EunsungContainedPath -Root $DeployRoot -Candidate $DeployRoot
  Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $DeployRoot
  $releaseRoot = Join-Path $DeployRoot 'releases'
  if (-not (Test-Path -LiteralPath $releaseRoot)) { New-Item -ItemType Directory -Path $releaseRoot | Out-Null }
  Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $releaseRoot
  $releaseDir = Resolve-EunsungContainedPath -Root $releaseRoot -Candidate (Join-Path $releaseRoot $CommitSha) -AllowMissing
  $attributeProvider = Get-EunsungAdapter -Adapters $Adapters -Name 'AttributeProvider' -Default $null
  $accessValidator = Get-EunsungAdapter -Adapters $Adapters -Name 'AccessValidator' -Default $null
  $native = Get-EunsungAdapter -Adapters $Adapters -Name 'NativeInvoker' -Default $null

  if ($ActivateExisting) {
    Assert-EunsungBuiltRelease -DeployRoot $DeployRoot -ReleaseDir $releaseDir -CommitSha $CommitSha -AccessValidator $accessValidator -AttributeProvider $attributeProvider
  } else {
    if ([IO.Path]::GetExtension($ArchivePath) -cne '.zip') { throw 'ArchivePath must be an Expand-Archive compatible .zip file' }
    $archive = Resolve-EunsungContainedPath -Root $DeployRoot -Candidate $ArchivePath
    Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $archive -AttributeProvider $attributeProvider
    Assert-EunsungOrdinaryFile -Path $archive -AttributeProvider $attributeProvider
    if (Test-Path -LiteralPath $releaseDir) { throw 'Release target already exists' }
    New-Item -ItemType Directory -Path $releaseDir | Out-Null
    Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $releaseDir -AttributeProvider $attributeProvider
    Expand-Archive -LiteralPath $archive -DestinationPath $releaseDir
    Copy-EunsungProtectedConfigs -DeployRoot $DeployRoot -ReleaseDir $releaseDir -AccessValidator $accessValidator -AttributeProvider $attributeProvider
    Set-Content -LiteralPath (Join-Path $releaseDir '.commit-sha') -Value $CommitSha -NoNewline -Encoding ASCII
    Invoke-EunsungBuild -ReleaseDir $releaseDir -CommitSha $CommitSha -NativeInvoker $native
  }

  if ($BuildOnly) {
    Assert-EunsungBuiltRelease -DeployRoot $DeployRoot -ReleaseDir $releaseDir -CommitSha $CommitSha -AccessValidator $accessValidator -AttributeProvider $attributeProvider
    return
  }
  Invoke-EunsungActivation -DeployRoot $DeployRoot -ReleaseDir $releaseDir -CommitSha $CommitSha -InjectHealthFailure:$InjectHealthFailure -Adapters $Adapters
}

Export-ModuleMember -Function @(
  'Test-EunsungCommitSha',
  'Resolve-EunsungContainedPath',
  'Assert-EunsungNoReparseAncestry',
  'Assert-EunsungOrdinaryFile',
  'ConvertTo-EunsungSanitizedDiagnostic',
  'Test-EunsungAclAccess',
  'Invoke-EunsungNative',
  'Invoke-EunsungBoundedHttp',
  'ConvertFrom-EunsungPm2Json',
  'Test-EunsungReleaseHealth',
  'Write-EunsungBuildMarker',
  'Assert-EunsungProtectedConfig',
  'Assert-EunsungBuiltRelease',
  'Remove-EunsungOldSuccessfulReleases',
  'Assert-EunsungDeploymentMode',
  'Invoke-EunsungActivation',
  'Invoke-EunsungDeployment'
)

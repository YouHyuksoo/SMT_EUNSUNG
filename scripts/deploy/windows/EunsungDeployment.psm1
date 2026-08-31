$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$script:DefaultDeployRoot = 'D:\Project\SMT_EUNSUNG\.deploy'
$script:ExpectedOutputs = @(
  'packages/shared/dist/index.js',
  'apps/backend/dist/main.js',
  'apps/frontend/.next/BUILD_ID'
)
$script:NonSecretConfigFiles = @('ecosystem.config.js', 'package.json', 'pnpm-lock.yaml')
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
        $pid = [int]$app[0].pid
        $owners = @(& $PortOwnerProvider ([int]$entry.Value))
        if ($pid -le 0 -or -not ($owners -contains $pid)) {
          $diagnostics.Add("PID does not own expected port: $($entry.Key):$($entry.Value)")
        }
      }

      $frontend = & $HttpInvoker 'http://127.0.0.1:3100/' $TimeoutSec
      if ([int]$frontend.StatusCode -lt 200 -or [int]$frontend.StatusCode -ge 400) {
        $diagnostics.Add('frontend HTTP request was not successful')
      }
      $backend = & $HttpInvoker 'http://127.0.0.1:3003/api/v1/health' $TimeoutSec
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

function Test-EunsungDefaultAccess {
  param([string]$Path)
  try {
    $stream = [IO.File]::Open($Path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::Read)
    $stream.Dispose()
    return $true
  } catch {
    return $false
  }
}

function Assert-EunsungProtectedConfig {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$ReleaseDir,
    [scriptblock]$AccessValidator,
    [scriptblock]$AttributeProvider
  )
  if (-not $AccessValidator) { $AccessValidator = { param($Path) Test-EunsungDefaultAccess -Path $Path } }
  foreach ($relativePath in @('apps/backend/.env', 'apps/frontend/config/database.json')) {
    $path = Join-Path $ReleaseDir $relativePath
    Assert-EunsungOrdinaryFile -Path $path -AttributeProvider $AttributeProvider
    if (-not (& $AccessValidator $path)) { throw 'Protected deployment config access validation failed' }
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
    [ValidateRange(0, 20)][int]$PriorSuccessesToKeep = 3
  )
  if (-not (Test-Path -LiteralPath $ReleaseRoot)) { return }
  $currentFull = [IO.Path]::GetFullPath($CurrentRelease)
  $prior = @(Get-ChildItem -LiteralPath $ReleaseRoot -Directory | Where-Object {
    $_.FullName -ne $currentFull -and (Test-Path -LiteralPath (Join-Path $_.FullName 'deployment.success.json') -PathType Leaf)
  } | Sort-Object LastWriteTimeUtc -Descending)
  @($prior | Select-Object -Skip $PriorSuccessesToKeep) | ForEach-Object {
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

function Get-EunsungSwitchState {
  param([string]$DeployRoot, [scriptblock]$NativeInvoker)
  $currentPath = Join-Path $DeployRoot 'current.json'
  $current = $null
  if (Test-Path -LiteralPath $currentPath -PathType Leaf) {
    try { $current = Get-Content -Raw -LiteralPath $currentPath | ConvertFrom-Json } catch { throw 'Current release marker is invalid' }
  }
  $apps = ConvertFrom-EunsungPm2Json -Json (Invoke-EunsungNative -FilePath 'pm2.cmd' -Arguments @('jlist') -NativeInvoker $NativeInvoker)
  $capturedApps = @($apps | Where-Object { $script:AppPorts.Contains($_.name) })
  $pm2Home = [Environment]::GetEnvironmentVariable('PM2_HOME', 'Process')
  if ([string]::IsNullOrWhiteSpace($pm2Home)) { $pm2Home = Join-Path $env:USERPROFILE '.pm2' }
  $dumpPath = Join-Path $pm2Home 'dump.pm2'
  $backup = $null
  if (Test-Path -LiteralPath $dumpPath -PathType Leaf) {
    $stateDir = Join-Path $DeployRoot 'state'
    New-Item -ItemType Directory -Force -Path $stateDir | Out-Null
    $backup = Join-Path $stateDir ("dump-before-$([guid]::NewGuid().ToString('N')).pm2")
    Copy-Item -LiteralPath $dumpPath -Destination $backup
  }
  return @{
    HasPrior = ($null -ne $current)
    CurrentMarker = $current
    Apps = $capturedApps
    DumpBackup = $backup
    DumpPath = $dumpPath
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
  foreach ($name in $script:AppPorts.Keys) {
    try { Invoke-EunsungNative -FilePath 'pm2.cmd' -Arguments @('delete', $name) -NativeInvoker $NativeInvoker | Out-Null } catch { }
  }
}

function Restore-EunsungPriorState {
  param([hashtable]$SwitchState, [scriptblock]$NativeInvoker)
  if ([string]::IsNullOrWhiteSpace([string]$SwitchState.DumpBackup)) { throw 'Prior PM2 dump backup is unavailable' }
  Copy-Item -LiteralPath $SwitchState.DumpBackup -Destination $SwitchState.DumpPath -Force
  Invoke-EunsungNative -FilePath 'pm2.cmd' -Arguments @('resurrect') -NativeInvoker $NativeInvoker | Out-Null
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
  $capture = Get-EunsungAdapter -Adapters $Adapters -Name 'CaptureSwitchState' -Default { param($Root) Get-EunsungSwitchState -DeployRoot $Root -NativeInvoker $native }
  $switch = Get-EunsungAdapter -Adapters $Adapters -Name 'SwitchApps' -Default { param($Release, $Root) Start-EunsungApps -ReleaseDir $Release -DeployRoot $Root -NativeInvoker $native }
  $stopNew = Get-EunsungAdapter -Adapters $Adapters -Name 'StopNewApps' -Default { Stop-EunsungNewApps -NativeInvoker $native }
  $restore = Get-EunsungAdapter -Adapters $Adapters -Name 'RestorePrior' -Default { param($State) Restore-EunsungPriorState -SwitchState $State -NativeInvoker $native }
  $save = Get-EunsungAdapter -Adapters $Adapters -Name 'SaveState' -Default { Invoke-EunsungNative -FilePath 'pm2.cmd' -Arguments @('save') -NativeInvoker $native | Out-Null }
  $health = Get-EunsungAdapter -Adapters $Adapters -Name 'HealthCheck' -Default {
    param($Expected, $Release)
    $markerSha = (Get-Content -Raw -LiteralPath (Join-Path $Release '.commit-sha')).Trim()
    Test-EunsungReleaseHealth -ExpectedSha $Expected -ReleaseMarkerSha $markerSha -Pm2ListProvider $pm2ListProvider -PortOwnerProvider $portOwnerProvider -HttpInvoker $httpInvoker -SleepAdapter $sleepAdapter
  }
  $rollbackHealth = Get-EunsungAdapter -Adapters $Adapters -Name 'RollbackHealthCheck' -Default {
    param($State)
    if ($null -eq $State.CurrentMarker) { return @{ Success = $false; Diagnostics = @('prior marker unavailable') } }
    $markerSha = (Get-Content -Raw -LiteralPath (Join-Path ([string]$State.CurrentMarker.releaseDir) '.commit-sha')).Trim()
    Test-EunsungReleaseHealth -ExpectedSha ([string]$State.CurrentMarker.commitSha) -ReleaseMarkerSha $markerSha -Pm2ListProvider $pm2ListProvider -PortOwnerProvider $portOwnerProvider -HttpInvoker $httpInvoker -SleepAdapter $sleepAdapter
  }
  $retention = Get-EunsungAdapter -Adapters $Adapters -Name 'Retention' -Default { param($Root, $Current) Remove-EunsungOldSuccessfulReleases -ReleaseRoot $Root -CurrentRelease $Current -PriorSuccessesToKeep 3 }

  $switchState = & $capture $DeployRoot
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

    $currentMarker = [ordered]@{ commitSha = $CommitSha; releaseDir = $ReleaseDir; activatedAtUtc = [DateTime]::UtcNow.ToString('o') }
    Set-EunsungCurrentMarker -DeployRoot $DeployRoot -Marker $currentMarker
    & $save
    Write-EunsungJsonAtomic -Path (Join-Path $ReleaseDir 'deployment.success.json') -Value $currentMarker
    & $retention (Join-Path $DeployRoot 'releases') $ReleaseDir
    return
  } catch {
    $failure = ConvertTo-EunsungSanitizedDiagnostic $_.Exception.Message
  }

  & $stopNew
  if (-not $switchState.HasPrior) {
    Set-EunsungCurrentMarker -DeployRoot $DeployRoot -Marker $null
    throw (New-EunsungFailureException -Message "Deployment failed with no prior release; new apps stopped. $failure" -ExitCode 30)
  }

  try {
    & $restore $switchState
    Set-EunsungCurrentMarker -DeployRoot $DeployRoot -Marker $switchState.CurrentMarker
    $restoredHealth = & $rollbackHealth $switchState
    if (-not $restoredHealth.Success) {
      $safeRollback = ($restoredHealth.Diagnostics | ForEach-Object { ConvertTo-EunsungSanitizedDiagnostic $_ }) -join '; '
      throw "rollback health failed. $safeRollback"
    }
    & $save
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
    Assert-EunsungOrdinaryFile -Path $mapping.Source -AttributeProvider $AttributeProvider
    if ($AccessValidator -and -not (& $AccessValidator $mapping.Source)) { throw 'Protected shared file access validation failed' }
    $parent = Split-Path -Parent $mapping.Destination
    if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    Copy-Item -LiteralPath $mapping.Source -Destination $mapping.Destination
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

  if ($BuildOnly) { return }
  Invoke-EunsungActivation -DeployRoot $DeployRoot -ReleaseDir $releaseDir -CommitSha $CommitSha -InjectHealthFailure:$InjectHealthFailure -Adapters $Adapters
}

Export-ModuleMember -Function @(
  'Test-EunsungCommitSha',
  'Resolve-EunsungContainedPath',
  'Assert-EunsungNoReparseAncestry',
  'Assert-EunsungOrdinaryFile',
  'ConvertTo-EunsungSanitizedDiagnostic',
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

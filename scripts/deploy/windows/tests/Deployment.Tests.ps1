$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

# Describe 'Eunsung deployment release transaction contracts'
$script:Passed = 0
$script:Failed = 0
$script:Skipped = 0

function Assert-True {
  param([bool]$Condition, [string]$Message = 'Expected condition to be true')
  if (-not $Condition) { throw $Message }
}

function Assert-Equal {
  param($Expected, $Actual, [string]$Message = 'Values differ')
  if ($Expected -ne $Actual) { throw "$Message. Expected=[$Expected] Actual=[$Actual]" }
}

function Assert-Match {
  param([string]$Pattern, [string]$Actual, [string]$Message = 'Value did not match')
  if ($Actual -notmatch $Pattern) { throw "$Message. Pattern=[$Pattern] Actual=[$Actual]" }
}

function Assert-Throws {
  param([scriptblock]$Action, [string]$Pattern)
  try {
    & $Action
  } catch {
    if ($_.Exception.Message -notmatch $Pattern) {
      throw "Exception did not match [$Pattern]: $($_.Exception.Message)"
    }
    return
  }
  throw "Expected exception matching [$Pattern]"
}

function Test-Case {
  param([string]$Name, [scriptblock]$Action)
  try {
    & $Action
    $script:Passed++
    Write-Host "PASS $Name"
  } catch {
    $script:Failed++
    Write-Host "FAIL $Name :: $($_.Exception.Message)"
  }
}

function New-TestRelease {
  param([string]$DeployRoot, [string]$Sha, [switch]$BadHash)

  $release = Join-Path (Join-Path $DeployRoot 'releases') $Sha
  New-Item -ItemType Directory -Force -Path (Join-Path $release 'apps/backend/dist') | Out-Null
  New-Item -ItemType Directory -Force -Path (Join-Path $release 'apps/frontend/.next') | Out-Null
  New-Item -ItemType Directory -Force -Path (Join-Path $release 'apps/frontend/config') | Out-Null
  New-Item -ItemType Directory -Force -Path (Join-Path $release 'packages/shared/dist') | Out-Null
  Set-Content -LiteralPath (Join-Path $release 'apps/backend/dist/main.js') -Value 'backend' -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $release 'apps/frontend/.next/BUILD_ID') -Value 'frontend' -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $release 'packages/shared/dist/index.js') -Value 'shared' -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $release 'apps/backend/.env') -Value 'DB_PASSWORD=never-print-this' -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $release 'apps/frontend/config/database.json') -Value '{"password":"never-print-this"}' -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $release 'ecosystem.config.js') -Value 'module.exports={apps:[]}' -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $release 'package.json') -Value '{}' -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $release 'pnpm-lock.yaml') -Value 'lockfileVersion: 9' -Encoding UTF8
  Set-Content -LiteralPath (Join-Path $release '.commit-sha') -Value $Sha -NoNewline -Encoding ASCII
  Write-EunsungBuildMarker -ReleaseDir $release -CommitSha $Sha
  if ($BadHash) {
    Set-Content -LiteralPath (Join-Path $release 'ecosystem.config.js') -Value 'tampered' -Encoding UTF8
  }
  return $release
}

function Get-TestFileSha256 {
  param([string]$Path)
  $stream = [IO.File]::OpenRead($Path)
  $sha256 = [Security.Cryptography.SHA256]::Create()
  try {
    return ([BitConverter]::ToString($sha256.ComputeHash($stream))).Replace('-', '')
  } finally {
    $sha256.Dispose()
    $stream.Dispose()
  }
}

$modulePath = Join-Path (Split-Path -Parent $PSScriptRoot) 'EunsungDeployment.psm1'
Import-Module $modulePath -Force

$shaA = '0123456789abcdef0123456789abcdef01234567'
$shaB = '89abcdef0123456789abcdef0123456789abcdef'
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("eunsung-deploy-tests-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tempRoot | Out-Null

try {
  Test-Case 'full 40-lowerhex SHA validation rejects uppercase, short, and punctuation' {
    Assert-True (Test-EunsungCommitSha $shaA)
    Assert-True (-not (Test-EunsungCommitSha $shaA.ToUpperInvariant()))
    Assert-True (-not (Test-EunsungCommitSha $shaA.Substring(0, 39)))
    Assert-True (-not (Test-EunsungCommitSha ($shaA.Substring(0, 39) + '-')))
  }

  Test-Case 'resolved containment rejects sibling prefix confusion' {
    $root = Join-Path $tempRoot 'deploy'
    New-Item -ItemType Directory -Force -Path $root | Out-Null
    $inside = Resolve-EunsungContainedPath -Root $root -Candidate (Join-Path $root 'releases/a') -AllowMissing
    Assert-Match 'releases' $inside
    Assert-Throws { Resolve-EunsungContainedPath -Root $root -Candidate ($root + '-evil/release') -AllowMissing } 'outside'
  }

  Test-Case 'reparse points in target ancestry are rejected with injectable attributes' {
    $root = Join-Path $tempRoot 'attrs'
    $target = Join-Path $root 'releases/a'
    New-Item -ItemType Directory -Force -Path $target | Out-Null
    $provider = { param($Path) if ($Path -match 'releases$') { [IO.FileAttributes]::Directory -bor [IO.FileAttributes]::ReparsePoint } else { [IO.FileAttributes]::Directory } }
    Assert-Throws { Assert-EunsungNoReparseAncestry -Root $root -Target $target -AttributeProvider $provider } 'reparse'
  }

  Test-Case 'an actual junction in release ancestry is rejected when the platform supports junctions' {
    $root = Join-Path $tempRoot 'junction-root'
    $outside = Join-Path $tempRoot 'junction-target'
    $junction = Join-Path $root 'releases'
    New-Item -ItemType Directory -Force -Path $root, $outside | Out-Null
    try {
      try {
        New-Item -ItemType Junction -Path $junction -Target $outside -ErrorAction Stop | Out-Null
      } catch {
        $script:Skipped++
        Write-Host "SKIP actual junction unavailable; mocked FileAttributes test above compensates: $($_.Exception.Message)"
        return
      }
      Assert-Throws { Assert-EunsungNoReparseAncestry -Root $root -Target $junction } 'reparse'
    } finally {
      if (Test-Path -LiteralPath $junction) { [IO.Directory]::Delete($junction) }
    }
  }

  Test-Case 'protected shared inputs must be ordinary non-reparse files' {
    $file = Join-Path $tempRoot 'shared.env'
    Set-Content -LiteralPath $file -Value 'secret' -Encoding UTF8
    $reparse = { param($Path) [IO.FileAttributes]::Archive -bor [IO.FileAttributes]::ReparsePoint }
    Assert-Throws { Assert-EunsungOrdinaryFile -Path $file -AttributeProvider $reparse } 'reparse'
    Assert-Throws { Assert-EunsungOrdinaryFile -Path (Join-Path $tempRoot 'missing.env') } 'ordinary file'
  }

  Test-Case 'native nonzero exit is a terminating failure' {
    $native = { param($FilePath, $Arguments, $WorkingDirectory, $Environment) @{ ExitCode = 17; Output = 'configuration payload impossible-to-redact-value' } }
    try {
      Invoke-EunsungNative -FilePath 'pnpm' -Arguments @('--version') -NativeInvoker $native
      throw 'expected native failure'
    } catch {
      Assert-Match '17' $_.Exception.Message
      Assert-True (-not $_.Exception.Message.Contains('impossible-to-redact-value'))
    }
  }

  Test-Case 'HTTP retries are bounded and pass timeout to the adapter' {
    $script:httpAttempts = 0
    $script:seenTimeout = 0
    $http = { param($Uri, $TimeoutSec) $script:httpAttempts++; $script:seenTimeout = $TimeoutSec; throw 'timeout' }
    $sleep = { param($Milliseconds) }
    Assert-Throws { Invoke-EunsungBoundedHttp -Uri 'http://127.0.0.1:1' -MaxAttempts 3 -TimeoutSec 2 -HttpInvoker $http -SleepAdapter $sleep } 'after 3 attempts'
    Assert-Equal 3 $script:httpAttempts
    Assert-Equal 2 $script:seenTimeout
  }

  Test-Case 'health rejects degraded database state' {
    $pm2 = { '[{"name":"eunsung-frontend","pid":101,"pm2_env":{"status":"online"}},{"name":"eunsung-backend","pid":202,"pm2_env":{"status":"online"}}]' }
    $ports = { param($Port) if ($Port -eq 3100) { @(101) } else { @(202) } }
    $http = { param($Uri, $TimeoutSec) if ($Uri -match 'health') { @{ StatusCode = 200; Body = '{"status":"ok","database":{"status":"degraded"}}' } } else { @{ StatusCode = 200; Body = 'ok' } } }
    $result = Test-EunsungReleaseHealth -ExpectedSha $shaA -ReleaseMarkerSha $shaA -Pm2ListProvider $pm2 -PortOwnerProvider $ports -HttpInvoker $http -MaxAttempts 1
    Assert-True (-not $result.Success)
    Assert-Match 'database' ($result.Diagnostics -join ' ')
  }

  Test-Case 'health rejects PID-to-port ownership mismatch' {
    $pm2 = { '[{"name":"eunsung-frontend","pid":101,"pm2_env":{"status":"online"}},{"name":"eunsung-backend","pid":202,"pm2_env":{"status":"online"}}]' }
    $ports = { param($Port) @(999) }
    $http = { param($Uri, $TimeoutSec) @{ StatusCode = 200; Body = '{"status":"ok","database":{"status":"connected"}}' } }
    $result = Test-EunsungReleaseHealth -ExpectedSha $shaA -ReleaseMarkerSha $shaA -Pm2ListProvider $pm2 -PortOwnerProvider $ports -HttpInvoker $http -MaxAttempts 1
    Assert-True (-not $result.Success)
    Assert-Match 'PID' ($result.Diagnostics -join ' ')
  }

  Test-Case 'health succeeds only with exact marker, online apps, owned ports and healthy HTTP' {
    $pm2 = { '[{"name":"eunsung-frontend","pid":101,"pm2_env":{"status":"online"}},{"name":"eunsung-backend","pid":202,"pm2_env":{"status":"online"}}]' }
    $ports = { param($Port) if ($Port -eq 3100) { @(101) } else { @(202) } }
    $http = { param($Uri, $TimeoutSec) if ($Uri -match 'health') { @{ StatusCode = 200; Body = '{"status":"ok","database":{"status":"connected"}}' } } else { @{ StatusCode = 204; Body = '' } } }
    $result = Test-EunsungReleaseHealth -ExpectedSha $shaA -ReleaseMarkerSha $shaA -Pm2ListProvider $pm2 -PortOwnerProvider $ports -HttpInvoker $http -MaxAttempts 1
    Assert-True $result.Success
  }

  Test-Case 'diagnostics redact environment, config, key, token and password content' {
    $message = 'DB_PASSWORD=hunter2 TOKEN=abc key: xyz env={secret} config={password} {"API_KEY":"json-secret"} C:\secret\backend.env'
    $safe = ConvertTo-EunsungSanitizedDiagnostic $message
    Assert-True (-not $safe.Contains('hunter2'))
    Assert-True (-not $safe.Contains('abc'))
    Assert-True (-not $safe.Contains('xyz'))
    Assert-True (-not $safe.Contains('{secret}'))
    Assert-True (-not $safe.Contains('{password}'))
    Assert-True (-not $safe.Contains('json-secret'))
  }

  Test-Case 'retention removes only old successful releases after success' {
    $root = Join-Path $tempRoot 'retention'
    $releases = Join-Path $root 'releases'
    New-Item -ItemType Directory -Force -Path $releases | Out-Null
    1..5 | ForEach-Object {
      $path = Join-Path $releases ("release$_")
      New-Item -ItemType Directory -Path $path | Out-Null
      Set-Content -LiteralPath (Join-Path $path 'deployment.success.json') -Value '{}' -Encoding UTF8
      (Get-Item -LiteralPath $path).LastWriteTimeUtc = [datetime]::UtcNow.AddMinutes(-$_)
    }
    $failed = Join-Path $releases 'failed'
    New-Item -ItemType Directory -Path $failed | Out-Null
    Remove-EunsungOldSuccessfulReleases -ReleaseRoot $releases -CurrentRelease (Join-Path $releases 'release1') -PriorSuccessesToKeep 3
    Assert-True (Test-Path -LiteralPath $failed)
    Assert-Equal 4 @((Get-ChildItem -LiteralPath $releases -Directory | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'deployment.success.json') })).Count
  }

  Test-Case 'build marker records exact SHA, expected outputs and non-secret config hashes' {
    $root = Join-Path $tempRoot 'marker'
    $release = New-TestRelease -DeployRoot $root -Sha $shaA
    $marker = Get-Content -Raw -LiteralPath (Join-Path $release 'build.complete.json') | ConvertFrom-Json
    Assert-Equal $shaA $marker.commitSha
    Assert-True ($marker.expectedOutputs.Count -ge 3)
    Assert-True ($null -ne $marker.configHashes.'ecosystem.config.js')
    Assert-EunsungBuiltRelease -DeployRoot $root -ReleaseDir $release -CommitSha $shaA
  }

  Test-Case 'activation validation rejects marker, hash, and protected access failures' {
    $root = Join-Path $tempRoot 'rejects'
    $release = New-TestRelease -DeployRoot $root -Sha $shaA -BadHash
    Assert-Throws { Assert-EunsungBuiltRelease -DeployRoot $root -ReleaseDir $release -CommitSha $shaA } 'hash'
    Set-Content -LiteralPath (Join-Path $release '.commit-sha') -Value $shaB -NoNewline -Encoding ASCII
    Assert-Throws { Assert-EunsungBuiltRelease -DeployRoot $root -ReleaseDir $release -CommitSha $shaA } 'marker'
    $acl = { param($Path) $false }
    Assert-Throws { Assert-EunsungProtectedConfig -ReleaseDir $release -AccessValidator $acl } 'access'
  }

  Test-Case 'deployment mode guard enforces archive, build-only and failure-injection rules' {
    Assert-Throws { Assert-EunsungDeploymentMode -ArchivePath 'a.zip' -ActivateExisting } 'archive'
    Assert-Throws { Assert-EunsungDeploymentMode -BuildOnly -ActivateExisting } 'mutually'
    Assert-Throws { Assert-EunsungDeploymentMode -InjectHealthFailure -ActivateExisting } 'AllowFailureInjection'
    Assert-Throws { Assert-EunsungDeploymentMode -InjectHealthFailure -AllowFailureInjection } 'ActivateExisting'
    Assert-EunsungDeploymentMode -InjectHealthFailure -AllowFailureInjection -ActivateExisting
  }

  Test-Case 'ActivateExisting performs no extract, install, or build and switches both apps' {
    $root = Join-Path $tempRoot 'activate'
    $release = New-TestRelease -DeployRoot $root -Sha $shaA
    $script:events = New-Object System.Collections.ArrayList
    $adapters = @{
      TestMode = $true
      CaptureSwitchState = { param($DeployRoot) @{ HasPrior = $false; CurrentMarker = $null; Apps = @(); DumpBackup = $null } }
      SwitchApps = { param($ReleaseDir, $DeployRoot) [void]$script:events.Add("switch:$ReleaseDir") }
      HealthCheck = { param($ExpectedSha, $ReleaseDir) @{ Success = $true; Diagnostics = @() } }
      SaveState = { [void]$script:events.Add('save') }
      Retention = { param($ReleaseRoot, $CurrentRelease) [void]$script:events.Add('retention') }
      NativeInvoker = { throw 'build command must not run' }
    }
    Invoke-EunsungDeployment -CommitSha $shaA -ActivateExisting -DeployRoot $root -Adapters $adapters
    Assert-Match '^switch:' ([string]$script:events[0])
    Assert-True ($script:events -contains 'save')
    Assert-True ($script:events -contains 'retention')
  }

  Test-Case 'successful switch saves only after health and writes exact current marker' {
    $root = Join-Path $tempRoot 'success'
    $release = New-TestRelease -DeployRoot $root -Sha $shaA
    $script:events = New-Object System.Collections.ArrayList
    $adapters = @{
      TestMode = $true
      CaptureSwitchState = { @{ HasPrior = $false; CurrentMarker = $null; Apps = @(); DumpBackup = 'original' } }
      HealthCheck = { [void]$script:events.Add('health'); @{ Success = $true; Diagnostics = @() } }
      Retention = { [void]$script:events.Add('retention') }
      NativeInvoker = {
        param($FilePath, $Arguments, $WorkingDirectory, $Environment)
        [void]$script:events.Add("native:$($Arguments -join ' ')")
        @{ ExitCode = 0; Output = '' }
      }
    }
    $oldOracleClient = [Environment]::GetEnvironmentVariable('ORACLE_CLIENT_LIB_DIR', 'Process')
    try {
      [Environment]::SetEnvironmentVariable('ORACLE_CLIENT_LIB_DIR', (Join-Path $tempRoot 'oracle-client'), 'Process')
      Invoke-EunsungDeployment -CommitSha $shaA -ActivateExisting -DeployRoot $root -Adapters $adapters
    } finally {
      [Environment]::SetEnvironmentVariable('ORACLE_CLIENT_LIB_DIR', $oldOracleClient, 'Process')
    }
    Assert-Match '^native:start .*--only eunsung-frontend,eunsung-backend --update-env$' ([string]$script:events[0])
    Assert-Equal 'health' ([string]$script:events[1])
    Assert-Equal 'native:save' ([string]$script:events[2])
    Assert-Equal 'retention' ([string]$script:events[3])
    $current = Get-Content -Raw -LiteralPath (Join-Path $root 'current.json') | ConvertFrom-Json
    Assert-Equal $shaA $current.commitSha
    Assert-Equal $release $current.releaseDir
  }

  Test-Case 'partial switch failure rolls back prior definitions and saves restored healthy state' {
    $root = Join-Path $tempRoot 'partial'
    New-TestRelease -DeployRoot $root -Sha $shaA | Out-Null
    $prior = New-TestRelease -DeployRoot $root -Sha $shaB
    $priorMarker = @{ commitSha = $shaB; releaseDir = $prior }
    $script:events = New-Object System.Collections.ArrayList
    $adapters = @{
      TestMode = $true
      CaptureSwitchState = { @{ HasPrior = $true; CurrentMarker = $priorMarker; Apps = @(@{name='eunsung-frontend'},@{name='eunsung-backend'}); DumpBackup = 'copy' } }
      SwitchApps = { [void]$script:events.Add('switch'); throw 'backend partial start' }
      StopNewApps = { [void]$script:events.Add('stop-new') }
      RestorePrior = { [void]$script:events.Add('restore-definitions-env-dump') }
      RollbackHealthCheck = { @{ Success = $true; Diagnostics = @() } }
      SaveState = { [void]$script:events.Add('save-restored') }
    }
    Assert-Throws { Invoke-EunsungDeployment -CommitSha $shaA -ActivateExisting -DeployRoot $root -Adapters $adapters } 'rolled back'
    Assert-Equal 'switch,stop-new,restore-definitions-env-dump,save-restored' ($script:events -join ',')
  }

  Test-Case 'rollback health failure is distinct and includes sanitized diagnostics' {
    $root = Join-Path $tempRoot 'rollback-fails'
    New-TestRelease -DeployRoot $root -Sha $shaA | Out-Null
    $prior = New-TestRelease -DeployRoot $root -Sha $shaB
    $adapters = @{
      TestMode = $true
      CaptureSwitchState = { @{ HasPrior = $true; CurrentMarker = @{commitSha=$shaB;releaseDir=$prior}; Apps = @(); DumpBackup = 'copy' } }
      SwitchApps = { throw 'new PASSWORD=hunter2' }
      StopNewApps = { }
      RestorePrior = { }
      RollbackHealthCheck = { @{ Success = $false; Diagnostics = @('DB_PASSWORD=hunter2 database disconnected') } }
      SaveState = { throw 'must not save unhealthy rollback' }
    }
    try {
      Invoke-EunsungDeployment -CommitSha $shaA -ActivateExisting -DeployRoot $root -Adapters $adapters
      throw 'expected rollback failure'
    } catch {
      Assert-Equal 31 $_.Exception.Data['ExitCode']
      Assert-True (-not $_.Exception.Message.Contains('hunter2'))
      Assert-Match 'rollback health failed' $_.Exception.Message
    }
  }

  Test-Case 'no-prior failure stops new apps, removes current marker, and preserves dump' {
    $root = Join-Path $tempRoot 'no-prior'
    New-TestRelease -DeployRoot $root -Sha $shaA | Out-Null
    Set-Content -LiteralPath (Join-Path $root 'current.json') -Value 'stale' -Encoding UTF8
    $script:stopped = $false
    $script:restored = $false
    $adapters = @{
      TestMode = $true
      CaptureSwitchState = { @{ HasPrior = $false; CurrentMarker = $null; Apps = @(); DumpBackup = 'original-untouched' } }
      SwitchApps = { }
      HealthCheck = { @{ Success = $false; Diagnostics = @('failed') } }
      StopNewApps = { $script:stopped = $true }
      RestorePrior = { $script:restored = $true }
    }
    Assert-Throws { Invoke-EunsungDeployment -CommitSha $shaA -ActivateExisting -DeployRoot $root -Adapters $adapters } 'no prior'
    Assert-True $script:stopped
    Assert-True (-not $script:restored)
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $root 'current.json')))
  }

  Test-Case 'injected post-switch health failure restores prior current release without config mutation' {
    $root = Join-Path $tempRoot 'inject'
    New-TestRelease -DeployRoot $root -Sha $shaA | Out-Null
    $prior = New-TestRelease -DeployRoot $root -Sha $shaB
    $secretPath = Join-Path $prior 'apps/backend/.env'
    $secretHash = Get-TestFileSha256 -Path $secretPath
    $priorMarker = @{ commitSha = $shaB; releaseDir = $prior }
    $script:healthCalled = $false
    $adapters = @{
      TestMode = $true
      CaptureSwitchState = { @{ HasPrior = $true; CurrentMarker = $priorMarker; Apps = @(); DumpBackup = 'copy' } }
      SwitchApps = { }
      HealthCheck = { $script:healthCalled = $true; @{ Success = $true; Diagnostics = @() } }
      StopNewApps = { }
      RestorePrior = { }
      RollbackHealthCheck = { @{ Success = $true; Diagnostics = @() } }
      SaveState = { }
    }
    Assert-Throws { Invoke-EunsungDeployment -CommitSha $shaA -ActivateExisting -InjectHealthFailure -AllowFailureInjection -DeployRoot $root -Adapters $adapters } 'rolled back'
    Assert-True (-not $script:healthCalled)
    $current = Get-Content -Raw -LiteralPath (Join-Path $root 'current.json') | ConvertFrom-Json
    Assert-Equal $shaB $current.commitSha
    Assert-Equal $secretHash (Get-TestFileSha256 -Path $secretPath)
  }
} finally {
  if (Test-Path -LiteralPath $tempRoot) {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force
  }
}

Write-Host "RESULT passed=$script:Passed failed=$script:Failed skipped=$script:Skipped"
if ($script:Failed -gt 0) { exit 1 }

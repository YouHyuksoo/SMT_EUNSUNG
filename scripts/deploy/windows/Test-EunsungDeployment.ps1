[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [string]$CommitSha,

  [string]$ReleaseDir,

  [string]$DeployRoot = 'D:\Project\SMT_EUNSUNG\.deploy',

  [ValidateRange(1, 20)]
  [int]$MaxAttempts = 10,

  [ValidateRange(1, 60)]
  [int]$TimeoutSec = 5,

  [ValidateRange(0, 60000)]
  [int]$RetryDelayMs = 2000,

  [string]$FrontendUrl = 'http://127.0.0.1:3100/',

  [string]$BackendUrl = 'http://127.0.0.1:3003/api/v1/health',

  [string]$Pm2Path = 'pm2.cmd',

  [string]$Pm2Home
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

Import-Module (Join-Path $PSScriptRoot 'EunsungDeployment.psm1') -Force

try {
  if (-not (Test-EunsungCommitSha $CommitSha)) {
    throw 'CommitSha must be exactly 40 lowercase hexadecimal characters'
  }

  $releaseRoot = Join-Path $DeployRoot 'releases'
  if ([string]::IsNullOrWhiteSpace($ReleaseDir)) { $ReleaseDir = Join-Path $releaseRoot $CommitSha }
  $DeployRoot = Resolve-EunsungContainedPath -Root $DeployRoot -Candidate $DeployRoot
  $ReleaseDir = Resolve-EunsungContainedPath -Root $releaseRoot -Candidate $ReleaseDir
  Assert-EunsungNoReparseAncestry -Root $DeployRoot -Target $ReleaseDir

  $releaseMarkerPath = Join-Path $ReleaseDir '.commit-sha'
  Assert-EunsungNoReparseAncestry -Root $ReleaseDir -Target $releaseMarkerPath
  Assert-EunsungOrdinaryFile -Path $releaseMarkerPath
  $releaseMarkerSha = (Get-Content -Raw -LiteralPath $releaseMarkerPath).Trim()
  if ($releaseMarkerSha -cne $CommitSha) {
    throw 'Release marker does not exactly match CommitSha'
  }

  $oldPm2Home = [Environment]::GetEnvironmentVariable('PM2_HOME', 'Process')
  try {
    if (-not [string]::IsNullOrWhiteSpace($Pm2Home)) { [Environment]::SetEnvironmentVariable('PM2_HOME', $Pm2Home, 'Process') }
    $pm2Provider = { Invoke-EunsungNative -FilePath $Pm2Path -Arguments @('jlist') }
    $result = Test-EunsungReleaseHealth `
      -ExpectedSha $CommitSha `
      -ReleaseMarkerSha $releaseMarkerSha `
      -ExpectedReleaseDir $ReleaseDir `
      -Pm2ListProvider $pm2Provider `
      -FrontendUrl $FrontendUrl `
      -BackendUrl $BackendUrl `
      -MaxAttempts $MaxAttempts `
      -TimeoutSec $TimeoutSec `
      -RetryDelayMs $RetryDelayMs
  } finally {
    if (-not [string]::IsNullOrWhiteSpace($Pm2Home)) { [Environment]::SetEnvironmentVariable('PM2_HOME', $oldPm2Home, 'Process') }
  }

  if (-not $result.Success) {
    $diagnostics = @($result.Diagnostics | ForEach-Object { ConvertTo-EunsungSanitizedDiagnostic $_ }) -join '; '
    throw "Release verification failed after $($result.Attempts) attempts. $diagnostics"
  }

  Write-Host "Deployment verified for commit $CommitSha"
  exit 0
} catch {
  $safe = ConvertTo-EunsungSanitizedDiagnostic $_.Exception.Message
  [Console]::Error.WriteLine("Deployment verification failed: $safe")
  exit 1
}

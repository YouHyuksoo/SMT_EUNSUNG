[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [string]$CommitSha,

  [Parameter(Mandatory)]
  [string]$ReleaseDir,

  [ValidateRange(1, 20)]
  [int]$MaxAttempts = 10,

  [ValidateRange(1, 60)]
  [int]$TimeoutSec = 5,

  [ValidateRange(0, 60000)]
  [int]$RetryDelayMs = 2000
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

Import-Module (Join-Path $PSScriptRoot 'EunsungDeployment.psm1') -Force

try {
  if (-not (Test-EunsungCommitSha $CommitSha)) {
    throw 'CommitSha must be exactly 40 lowercase hexadecimal characters'
  }

  $releaseMarkerPath = Join-Path $ReleaseDir '.commit-sha'
  Assert-EunsungOrdinaryFile -Path $releaseMarkerPath
  $releaseMarkerSha = (Get-Content -Raw -LiteralPath $releaseMarkerPath).Trim()
  if ($releaseMarkerSha -cne $CommitSha) {
    throw 'Release marker does not exactly match CommitSha'
  }

  $result = Test-EunsungReleaseHealth `
    -ExpectedSha $CommitSha `
    -ReleaseMarkerSha $releaseMarkerSha `
    -MaxAttempts $MaxAttempts `
    -TimeoutSec $TimeoutSec `
    -RetryDelayMs $RetryDelayMs

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

[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [string]$CommitSha,

  [string]$ArchivePath,

  [switch]$BuildOnly,

  [switch]$ActivateExisting,

  [switch]$InjectHealthFailure,

  [switch]$AllowFailureInjection,

  # Non-default values are accepted only together with injected TestMode adapters.
  [string]$DeployRoot = 'D:\Project\SMT_EUNSUNG\.deploy',

  [hashtable]$Adapters
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

Import-Module (Join-Path $PSScriptRoot 'EunsungDeployment.psm1') -Force

try {
  Invoke-EunsungDeployment `
    -CommitSha $CommitSha `
    -ArchivePath $ArchivePath `
    -BuildOnly:$BuildOnly `
    -ActivateExisting:$ActivateExisting `
    -InjectHealthFailure:$InjectHealthFailure `
    -AllowFailureInjection:$AllowFailureInjection `
    -DeployRoot $DeployRoot `
    -Adapters $Adapters
  exit 0
} catch {
  $safe = ConvertTo-EunsungSanitizedDiagnostic $_.Exception.Message
  [Console]::Error.WriteLine("Deployment failed: $safe")
  $exitCode = 1
  if ($_.Exception.Data.Contains('ExitCode')) {
    $exitCode = [int]$_.Exception.Data['ExitCode']
  }
  exit $exitCode
}

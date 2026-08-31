[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [string]$CommitSha,

  [string]$ArchivePath,

  [switch]$BuildOnly,

  [switch]$ActivateExisting,

  [switch]$InjectHealthFailure,

  [switch]$AllowFailureInjection,

  [switch]$CleanupIncoming,

  # Non-default values are accepted only together with injected TestMode adapters.
  [string]$DeployRoot = 'D:\Project\SMT_EUNSUNG\.deploy',

  [hashtable]$Adapters
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$cleanupPath = $null
if ($CleanupIncoming) {
  if ($CommitSha -cnotmatch '^[0-9a-f]{40}$') {
    throw 'CommitSha must be a lowercase full SHA before incoming cleanup is enabled'
  }
  $isTestMode = ($Adapters -and $Adapters.ContainsKey('TestMode') -and $Adapters.TestMode)
  $isProductionRoot = ($DeployRoot -eq 'D:\Project\SMT_EUNSUNG\.deploy')
  $isIsolatedTestMode = ($isTestMode -and -not $isProductionRoot)
  if (-not $isProductionRoot -and -not $isIsolatedTestMode) {
    throw 'Incoming cleanup is permitted only under the production deployment root'
  }
  $expectedIncoming = [IO.Path]::GetFullPath((Join-Path (Join-Path $DeployRoot 'incoming') $CommitSha))
  $scriptDirectory = [IO.Path]::GetFullPath($PSScriptRoot)
  if ($scriptDirectory -cne $expectedIncoming) {
    throw 'Deployment script is not running from its exact SHA-specific incoming directory'
  }
  if (-not $isIsolatedTestMode) {
    $currentSid = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    $incomingAcl = Get-Acl -LiteralPath $scriptDirectory
    $ownerSid = $incomingAcl.GetOwner([Security.Principal.SecurityIdentifier]).Value
    if ($ownerSid -ne $currentSid) {
      throw 'Incoming directory is not owned by the deployment identity'
    }
    $allowedWriteSids = @($currentSid, 'S-1-5-18', 'S-1-5-32-544')
    $writeMask = [Security.AccessControl.FileSystemRights]::WriteData `
      -bor [Security.AccessControl.FileSystemRights]::CreateFiles `
      -bor [Security.AccessControl.FileSystemRights]::AppendData `
      -bor [Security.AccessControl.FileSystemRights]::CreateDirectories `
      -bor [Security.AccessControl.FileSystemRights]::Delete `
      -bor [Security.AccessControl.FileSystemRights]::DeleteSubdirectoriesAndFiles `
      -bor [Security.AccessControl.FileSystemRights]::ChangePermissions `
      -bor [Security.AccessControl.FileSystemRights]::TakeOwnership
    $currentHasWrite = $false
    foreach ($rule in $incomingAcl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier])) {
      $ruleSid = $rule.IdentityReference.Value
      $canWrite = (($rule.FileSystemRights -band $writeMask) -ne 0)
      if ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow -and $canWrite) {
        if ($allowedWriteSids -notcontains $ruleSid) {
          throw 'Incoming directory grants write access outside the deployment identity and administrators'
        }
        if ($ruleSid -eq $currentSid) { $currentHasWrite = $true }
      }
    }
    if (-not $currentHasWrite) {
      throw 'Incoming directory does not grant write access to the deployment identity'
    }
  }
  $cursor = $scriptDirectory
  $rootFull = [IO.Path]::GetFullPath($DeployRoot)
  while ($true) {
    $item = Get-Item -LiteralPath $cursor -Force
    if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
      throw 'Incoming directory ancestry contains a reparse point'
    }
    if ($cursor -eq $rootFull) { break }
    $cursor = [IO.Path]::GetFullPath((Split-Path -Parent $cursor))
  }
  $cleanupPath = $scriptDirectory
}

$exitCode = 0
try {
  Import-Module (Join-Path $PSScriptRoot 'EunsungDeployment.psm1') -Force
  Invoke-EunsungDeployment `
    -CommitSha $CommitSha `
    -ArchivePath $ArchivePath `
    -BuildOnly:$BuildOnly `
    -ActivateExisting:$ActivateExisting `
    -InjectHealthFailure:$InjectHealthFailure `
    -AllowFailureInjection:$AllowFailureInjection `
    -DeployRoot $DeployRoot `
    -Adapters $Adapters
} catch {
  $sanitizer = Get-Command ConvertTo-EunsungSanitizedDiagnostic -ErrorAction SilentlyContinue
  $safe = if ($sanitizer) { ConvertTo-EunsungSanitizedDiagnostic $_.Exception.Message } else { 'Deployment initialization failed before diagnostics were available' }
  [Console]::Error.WriteLine("Deployment failed: $safe")
  $exitCode = 1
  if ($_.Exception.Data.Contains('ExitCode')) {
    $reportedExitCode = [int]$_.Exception.Data['ExitCode']
    if ($reportedExitCode -ge 1 -and $reportedExitCode -le 255) {
      $exitCode = $reportedExitCode
    }
  }
} finally {
  if ($cleanupPath) {
    $unsafeEntry = Get-ChildItem -LiteralPath $cleanupPath -Force -Recurse | Where-Object {
      ($_.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0
    } | Select-Object -First 1
    if ($unsafeEntry) {
      [Console]::Error.WriteLine('Incoming cleanup refused because a reparse point was found')
      if ($exitCode -eq 0) { $exitCode = 1 }
    } else {
      Remove-Item -LiteralPath $cleanupPath -Force -Recurse
    }
  }
}
exit $exitCode

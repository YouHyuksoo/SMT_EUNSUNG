[CmdletBinding()]
param(
  [Parameter(Mandatory)][string]$DeployRoot,
  [Parameter(Mandatory)][string]$IncomingId,
  [ValidateSet('Prepare', 'Cleanup')][string]$Action = 'Prepare',
  [switch]$TestMode
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

if ($DeployRoot -ne 'D:\Project\SMT_EUNSUNG\.deploy' -and -not $TestMode) { throw 'Unexpected deployment root' }
if ($IncomingId -cnotmatch '^[0-9a-f]{40}-[1-9][0-9]*-[1-9][0-9]*$') { throw 'Invalid incoming identifier' }

$incomingRoot = [IO.Path]::GetFullPath((Join-Path $DeployRoot 'incoming'))
$target = [IO.Path]::GetFullPath((Join-Path $incomingRoot $IncomingId))
$expectedScript = [IO.Path]::GetFullPath((Join-Path $incomingRoot "prepare-$IncomingId.ps1"))
if ([IO.Path]::GetFullPath($PSCommandPath) -cne $expectedScript) { throw 'Preparation script is not at its exact expected path' }
if (-not $target.StartsWith($incomingRoot + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Incoming target escaped its root' }

try {
  foreach ($path in @($DeployRoot, $incomingRoot)) {
    $item = Get-Item -LiteralPath $path -Force
    if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw 'Incoming ancestry contains a reparse point' }
  }
  if ($Action -eq 'Prepare') {
    if (Test-Path -LiteralPath $target) { throw 'Incoming target already exists; refusing stale-path reuse' }
    New-Item -ItemType Directory -Path $target -ErrorAction Stop | Out-Null
    $created = Get-Item -LiteralPath $target -Force
    if (($created.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw 'Created incoming target is a reparse point' }
  } elseif (Test-Path -LiteralPath $target) {
    $targetItem = Get-Item -LiteralPath $target -Force
    if (-not $targetItem.PSIsContainer -or (($targetItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)) {
      throw 'Cleanup target must be an ordinary directory'
    }
    if (-not $TestMode) {
      $currentSid = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
      $targetAcl = Get-Acl -LiteralPath $target
      $ownerSid = $targetAcl.GetOwner([Security.Principal.SecurityIdentifier]).Value
      if ($ownerSid -ne $currentSid) { throw 'Cleanup target is not owned by the deployment identity' }
      $allowedWriteSids = @($currentSid, 'S-1-5-18', 'S-1-5-32-544')
      $writeMask = [Security.AccessControl.FileSystemRights]::WriteData `
        -bor [Security.AccessControl.FileSystemRights]::AppendData `
        -bor [Security.AccessControl.FileSystemRights]::Delete `
        -bor [Security.AccessControl.FileSystemRights]::DeleteSubdirectoriesAndFiles `
        -bor [Security.AccessControl.FileSystemRights]::ChangePermissions `
        -bor [Security.AccessControl.FileSystemRights]::TakeOwnership
      foreach ($rule in $targetAcl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier])) {
        if ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow -and
            ($rule.FileSystemRights -band $writeMask) -ne 0 -and
            $allowedWriteSids -notcontains $rule.IdentityReference.Value) {
          throw 'Cleanup target grants write access outside the deployment identity and administrators'
        }
      }
    }
    $pending = New-Object 'Collections.Generic.Queue[string]'
    $pending.Enqueue($target)
    while ($pending.Count -gt 0) {
      $directory = $pending.Dequeue()
      foreach ($child in @(Get-ChildItem -LiteralPath $directory -Force)) {
        if (($child.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw 'Cleanup target contains a reparse point' }
        if ($child.PSIsContainer) { $pending.Enqueue($child.FullName) }
      }
    }
    Remove-Item -LiteralPath $target -Recurse -Force
  }
} finally {
  if (Test-Path -LiteralPath $expectedScript -PathType Leaf) {
    Remove-Item -LiteralPath $expectedScript -Force
  }
}

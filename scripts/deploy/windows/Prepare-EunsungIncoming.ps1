[CmdletBinding()]
param(
  [Parameter(Mandatory)][string]$DeployRoot,
  [Parameter(Mandatory)][string]$IncomingId,
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
  if (Test-Path -LiteralPath $target) { throw 'Incoming target already exists; refusing stale-path reuse' }
  New-Item -ItemType Directory -Path $target -ErrorAction Stop | Out-Null
  $created = Get-Item -LiteralPath $target -Force
  if (($created.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw 'Created incoming target is a reparse point' }
} finally {
  if (Test-Path -LiteralPath $expectedScript -PathType Leaf) {
    Remove-Item -LiteralPath $expectedScript -Force
  }
}

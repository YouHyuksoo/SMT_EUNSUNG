[CmdletBinding()]
param(
  [ValidateSet('Initialize', 'Rollback')]
  [string]$Action = 'Initialize',

  [string]$PublicKey,

  [string]$DeployRoot,

  [string]$OracleClientLibDir,

  [string]$NodePath = 'C:\Program Files\nodejs\node.exe',

  [string]$NpmPath = 'C:\Program Files\nodejs\npm.cmd',

  [switch]$LibraryOnly
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$script:AccountName = 'eunsung-deploy'
$script:TaskName = 'EunsungMES-PM2-Resurrect'
$script:TaskPath = '\EunsungMES\'
$script:PnpmVersion = '10.28.1'
$script:Pm2Version = '6.0.6'
$script:BatchLogonRight = 'SeBatchLogonRight'
$script:BootstrapStateFileName = 'bootstrap-state.json'

function Initialize-EunsungLsaNativeType {
  if ('Eunsung.Deployment.LsaRights' -as [type]) { return }
  Add-Type -TypeDefinition @'
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Security.Principal;
namespace Eunsung.Deployment {
  public static class LsaRights {
    [StructLayout(LayoutKind.Sequential)] private struct LSA_UNICODE_STRING { public UInt16 Length; public UInt16 MaximumLength; public IntPtr Buffer; }
    [StructLayout(LayoutKind.Sequential)] private struct LSA_OBJECT_ATTRIBUTES { public UInt32 Length; public IntPtr RootDirectory; public IntPtr ObjectName; public UInt32 Attributes; public IntPtr SecurityDescriptor; public IntPtr SecurityQualityOfService; }
    [DllImport("advapi32.dll", PreserveSig=true)] private static extern UInt32 LsaOpenPolicy(IntPtr systemName, ref LSA_OBJECT_ATTRIBUTES attributes, UInt32 access, out IntPtr handle);
    [DllImport("advapi32.dll", PreserveSig=true)] private static extern UInt32 LsaClose(IntPtr handle);
    [DllImport("advapi32.dll", PreserveSig=true)] private static extern UInt32 LsaNtStatusToWinError(UInt32 status);
    [DllImport("advapi32.dll", PreserveSig=true)] private static extern UInt32 LsaEnumerateAccountRights(IntPtr policy, IntPtr sid, out IntPtr rights, out UInt32 count);
    [DllImport("advapi32.dll", PreserveSig=true)] private static extern UInt32 LsaAddAccountRights(IntPtr policy, IntPtr sid, LSA_UNICODE_STRING[] rights, UInt32 count);
    [DllImport("advapi32.dll", PreserveSig=true)] private static extern UInt32 LsaRemoveAccountRights(IntPtr policy, IntPtr sid, [MarshalAs(UnmanagedType.Bool)] bool allRights, LSA_UNICODE_STRING[] rights, UInt32 count);
    [DllImport("advapi32.dll", PreserveSig=true)] private static extern UInt32 LsaFreeMemory(IntPtr buffer);
    private const UInt32 POLICY_LOOKUP_NAMES=0x800, POLICY_CREATE_ACCOUNT=0x10, STATUS_OBJECT_NAME_NOT_FOUND=0xC0000034;
    private static void Check(UInt32 status,string op) { if(status!=0) throw new Win32Exception((int)LsaNtStatusToWinError(status),op); }
    private static LSA_UNICODE_STRING ToLsa(string value) { IntPtr p=Marshal.StringToHGlobalUni(value); return new LSA_UNICODE_STRING{Buffer=p,Length=(UInt16)(value.Length*2),MaximumLength=(UInt16)((value.Length+1)*2)}; }
    private static IntPtr Open() { var a=new LSA_OBJECT_ATTRIBUTES(); a.Length=(UInt32)Marshal.SizeOf(typeof(LSA_OBJECT_ATTRIBUTES)); IntPtr h; Check(LsaOpenPolicy(IntPtr.Zero,ref a,POLICY_LOOKUP_NAMES|POLICY_CREATE_ACCOUNT,out h),"LsaOpenPolicy"); return h; }
    private static IntPtr SidPtr(string sid) { var s=new SecurityIdentifier(sid); byte[] b=new byte[s.BinaryLength]; s.GetBinaryForm(b,0); IntPtr p=Marshal.AllocHGlobal(b.Length); Marshal.Copy(b,0,p,b.Length); return p; }
    public static bool HasRight(string sid,string right) { IntPtr h=IntPtr.Zero,p=IntPtr.Zero,b=IntPtr.Zero; try { h=Open(); p=SidPtr(sid); UInt32 count; UInt32 status=LsaEnumerateAccountRights(h,p,out b,out count); if(status==STATUS_OBJECT_NAME_NOT_FOUND)return false; Check(status,"LsaEnumerateAccountRights"); int size=Marshal.SizeOf(typeof(LSA_UNICODE_STRING)); for(int i=0;i<count;i++){ var u=(LSA_UNICODE_STRING)Marshal.PtrToStructure(new IntPtr(b.ToInt64()+i*size),typeof(LSA_UNICODE_STRING)); if(String.Equals(Marshal.PtrToStringUni(u.Buffer,u.Length/2),right,StringComparison.Ordinal))return true; } return false; } finally { if(b!=IntPtr.Zero)LsaFreeMemory(b); if(p!=IntPtr.Zero)Marshal.FreeHGlobal(p); if(h!=IntPtr.Zero)LsaClose(h); } }
    public static void AddRight(string sid,string right) { Change(sid,right,true); }
    public static void RemoveRight(string sid,string right) { Change(sid,right,false); }
    private static void Change(string sid,string right,bool add) { IntPtr h=IntPtr.Zero,p=IntPtr.Zero; var r=ToLsa(right); try { h=Open(); p=SidPtr(sid); var rights=new[]{r}; UInt32 status=add?LsaAddAccountRights(h,p,rights,1):LsaRemoveAccountRights(h,p,false,rights,1); Check(status,add?"LsaAddAccountRights":"LsaRemoveAccountRights"); } finally { if(r.Buffer!=IntPtr.Zero)Marshal.FreeHGlobal(r.Buffer); if(p!=IntPtr.Zero)Marshal.FreeHGlobal(p); if(h!=IntPtr.Zero)LsaClose(h); } }
  }
}
'@
}

function Get-EunsungLsaRightManager {
  Initialize-EunsungLsaNativeType
  return @{ Has={ param($Sid,$Right) [Eunsung.Deployment.LsaRights]::HasRight($Sid,$Right) }; Add={ param($Sid,$Right) [Eunsung.Deployment.LsaRights]::AddRight($Sid,$Right) }; Remove={ param($Sid,$Right) [Eunsung.Deployment.LsaRights]::RemoveRight($Sid,$Right) } }
}

function Assert-EunsungBootstrapStatePath {
  param([Parameter(Mandatory)][string]$DeployRoot,[Parameter(Mandatory)][string]$MarkerPath)
  $root = [IO.Path]::GetFullPath($DeployRoot).TrimEnd('\')
  $expected = [IO.Path]::GetFullPath((Join-Path $root "state\$($script:BootstrapStateFileName)"))
  if ([IO.Path]::GetFullPath($MarkerPath) -cne $expected) { throw 'Bootstrap state marker path is not the exact protected state path.' }
  Assert-EunsungOrdinaryPath -Path $root
  Assert-EunsungOrdinaryPath -Path (Split-Path -Parent $expected)
  if (Test-Path -LiteralPath $expected) { Assert-EunsungOrdinaryPath -Path $expected }
  return $expected
}

function Set-EunsungBootstrapStateAcl {
  param([Parameter(Mandatory)][string]$Path)
  $administratorsSid = New-Object Security.Principal.SecurityIdentifier('S-1-5-32-544')
  $systemSid = New-Object Security.Principal.SecurityIdentifier('S-1-5-18')
  $acl = New-Object Security.AccessControl.FileSecurity
  $acl.SetAccessRuleProtection($true,$false)
  foreach($sid in @($administratorsSid,$systemSid)){[void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($sid,'FullControl','Allow')))}
  $acl.SetOwner($administratorsSid)
  (New-Object IO.FileInfo($Path)).SetAccessControl($acl)
}

function Assert-EunsungBootstrapStateAcl {
  param([Parameter(Mandatory)][string]$Path)
  $acl=(New-Object IO.FileInfo($Path)).GetAccessControl()
  if(-not $acl.AreAccessRulesProtected){throw 'Bootstrap state marker ACL inheritance must be disabled.'}
  $ownerSid=([Security.Principal.NTAccount]$acl.Owner).Translate([Security.Principal.SecurityIdentifier]).Value
  if($ownerSid -cne 'S-1-5-32-544'){throw 'Bootstrap state marker owner must be Administrators.'}
  $rules=@($acl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]))
  if($rules.Count -ne 2){throw 'Bootstrap state marker ACL must contain exactly Administrators and SYSTEM.'}
  foreach($sid in @('S-1-5-32-544','S-1-5-18')){
    $matching=@($rules|Where-Object{$_.IdentityReference.Value -ceq $sid -and $_.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow -and ($_.FileSystemRights -band [Security.AccessControl.FileSystemRights]::FullControl) -eq [Security.AccessControl.FileSystemRights]::FullControl})
    if($matching.Count -ne 1){throw 'Bootstrap state marker ACL is not the exact protected contract.'}
  }
}

function Get-EunsungBootstrapState {
  param([Parameter(Mandatory)][string]$DeployRoot,[Parameter(Mandatory)][string]$MarkerPath)
  $path=Assert-EunsungBootstrapStatePath -DeployRoot $DeployRoot -MarkerPath $MarkerPath
  if(-not (Test-Path -LiteralPath $path)){return $null}
  Assert-EunsungBootstrapStateAcl -Path $path
  try{$marker=Get-Content -Raw -LiteralPath $path|ConvertFrom-Json}catch{throw 'Deployment bootstrap state marker is invalid JSON.'}
  $names=@($marker.PSObject.Properties.Name)
  $missing=@(@('schemaVersion','deploySid','batchLogonRightAddedByBootstrap')|Where-Object{$names -cnotcontains $_})
  if($names.Count -ne 3 -or $missing.Count -ne 0){throw 'Deployment bootstrap state marker schema is invalid.'}
  if($marker.schemaVersion -isnot [int] -or $marker.schemaVersion -ne 1 -or $marker.deploySid -isnot [string] -or $marker.batchLogonRightAddedByBootstrap -isnot [bool]){throw 'Deployment bootstrap state marker types are invalid.'}
  try{$normalized=(New-Object Security.Principal.SecurityIdentifier($marker.deploySid)).Value}catch{throw 'Deployment bootstrap state marker SID is invalid.'}
  if($normalized -cne $marker.deploySid){throw 'Deployment bootstrap state marker SID is not canonical.'}
  return $marker
}

function Set-EunsungBootstrapState {
  param([string]$DeployRoot,[string]$MarkerPath,[Security.Principal.SecurityIdentifier]$DeploySid,[bool]$Added)
  $path=Assert-EunsungBootstrapStatePath -DeployRoot $DeployRoot -MarkerPath $MarkerPath
  if(Test-Path -LiteralPath $path){[void](Get-EunsungBootstrapState -DeployRoot $DeployRoot -MarkerPath $path)}
  $temporary="$path.tmp"
  if(Test-Path -LiteralPath $temporary){Assert-EunsungOrdinaryPath -Path $temporary; throw 'Refusing to replace an existing bootstrap state temporary file.'}
  try{
    $payload=[ordered]@{schemaVersion=1;deploySid=$DeploySid.Value;batchLogonRightAddedByBootstrap=$Added}
    [IO.File]::WriteAllText($temporary,($payload|ConvertTo-Json -Compress),(New-Object Text.UTF8Encoding($false)))
    Set-EunsungBootstrapStateAcl -Path $temporary
    Assert-EunsungBootstrapStateAcl -Path $temporary
    Move-Item -LiteralPath $temporary -Destination $path -Force
    Assert-EunsungBootstrapStateAcl -Path $path
  }catch{
    if(Test-Path -LiteralPath $temporary){
      Assert-EunsungOrdinaryPath -Path $temporary
      Set-EunsungBootstrapStateAcl -Path $temporary
      Assert-EunsungBootstrapStateAcl -Path $temporary
      Remove-Item -LiteralPath $temporary -Force
    }
    throw
  }
}

function Ensure-EunsungBatchLogonRight {
  param([Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid,[Parameter(Mandatory)][string]$DeployRoot,[Parameter(Mandatory)][string]$MarkerPath,[hashtable]$RightManager=(Get-EunsungLsaRightManager))
  $marker=Get-EunsungBootstrapState -DeployRoot $DeployRoot -MarkerPath $MarkerPath
  if($marker -and [string]$marker.deploySid -cne $DeploySid.Value){throw 'Deployment bootstrap state marker does not match the exact deployment SID.'}
  if([bool](& $RightManager.Has $DeploySid.Value $script:BatchLogonRight)){if($null -eq $marker){Set-EunsungBootstrapState -DeployRoot $DeployRoot -MarkerPath $MarkerPath -DeploySid $DeploySid -Added $false};return}
  & $RightManager.Add $DeploySid.Value $script:BatchLogonRight
  try{
    if(-not [bool](& $RightManager.Has $DeploySid.Value $script:BatchLogonRight)){throw 'LSA did not confirm SeBatchLogonRight after adding it.'}
    Set-EunsungBootstrapState -DeployRoot $DeployRoot -MarkerPath $MarkerPath -DeploySid $DeploySid -Added $true
  }catch{
    $primaryType=$_.Exception.GetType().Name;$cleanup='removed'
    try{& $RightManager.Remove $DeploySid.Value $script:BatchLogonRight;if([bool](& $RightManager.Has $DeploySid.Value $script:BatchLogonRight)){$cleanup='removal-unconfirmed'}}catch{$cleanup='removal-failed-'+$_.Exception.GetType().Name}
    throw "Batch logon right provisioning failed ($primaryType); cleanup=$cleanup."
  }
}

function Remove-EunsungOwnedBatchLogonRight {
  param([Parameter(Mandatory)][string]$DeployRoot,[Parameter(Mandatory)][string]$MarkerPath,[Security.Principal.SecurityIdentifier]$ExpectedDeploySid,[hashtable]$RightManager=(Get-EunsungLsaRightManager))
  $marker=Get-EunsungBootstrapState -DeployRoot $DeployRoot -MarkerPath $MarkerPath
  if($null -eq $marker){return}
  if($ExpectedDeploySid -and [string]$marker.deploySid -cne $ExpectedDeploySid.Value){throw 'Deployment bootstrap state marker does not match the exact deployment SID.'}
  $markerSid=New-Object Security.Principal.SecurityIdentifier($marker.deploySid)
  if($marker.batchLogonRightAddedByBootstrap -and [bool](& $RightManager.Has $markerSid.Value $script:BatchLogonRight)){& $RightManager.Remove $markerSid.Value $script:BatchLogonRight;if([bool](& $RightManager.Has $markerSid.Value $script:BatchLogonRight)){throw 'LSA still reports SeBatchLogonRight after rollback removal.'}}
  Assert-EunsungBootstrapStateAcl -Path $MarkerPath
  Remove-Item -LiteralPath $MarkerPath -Force
}

function Assert-EunsungAdministrator {
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = New-Object Security.Principal.WindowsPrincipal($identity)
  if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Initialize-EunsungDeployServer.ps1 must run from an elevated Administrator session.'
  }
}

function Assert-EunsungBootstrapPath {
  param(
    [Parameter(Mandatory)][string]$Root,
    [Parameter(Mandatory)][string]$Candidate,
    [switch]$AllowRoot
  )

  $rootFull = [IO.Path]::GetFullPath($Root).TrimEnd('\')
  $candidateFull = [IO.Path]::GetFullPath($Candidate).TrimEnd('\')
  if ($candidateFull -ieq $rootFull) {
    if (-not $AllowRoot) { throw "Path must be below deployment root: $candidateFull" }
    return $candidateFull
  }
  if (-not $candidateFull.StartsWith($rootFull + '\', [StringComparison]::OrdinalIgnoreCase)) {
    throw "Path escapes deployment root: $candidateFull"
  }
  return $candidateFull
}

function Assert-EunsungOrdinaryPath {
  param([Parameter(Mandatory)][string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) { throw "Required path does not exist: $Path" }
  $current = [IO.Path]::GetFullPath($Path)
  while ($current) {
    $item = Get-Item -LiteralPath $current -Force
    if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
      throw "Reparse points are not allowed in bootstrap paths: $current"
    }
    if($item.PSObject.Properties.Name -contains 'LinkType' -and [string]$item.LinkType -eq 'HardLink'){throw "Hard links are not allowed in bootstrap paths: $current"}
    $parent = Split-Path -Parent $current
    if (-not $parent -or $parent -eq $current) { break }
    $current = $parent
  }
}

function New-EunsungRandomPassword {
  $bytes = New-Object byte[] 48
  [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
  $random = [Convert]::ToBase64String($bytes)
  $secure = New-Object Security.SecureString
  foreach ($character in ("E!9a$random").ToCharArray()) { $secure.AppendChar($character) }
  $secure.MakeReadOnly()
  return $secure
}

function Set-EunsungDirectoryAcl {
  param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid
  )

  $administratorsSid = New-Object Security.Principal.SecurityIdentifier('S-1-5-32-544')
  $systemSid = New-Object Security.Principal.SecurityIdentifier('S-1-5-18')
  $acl = New-Object Security.AccessControl.DirectorySecurity
  $acl.SetAccessRuleProtection($true, $false)
  $inherit = [Security.AccessControl.InheritanceFlags]'ContainerInherit, ObjectInherit'
  $propagation = [Security.AccessControl.PropagationFlags]::None
  $allow = [Security.AccessControl.AccessControlType]::Allow
  [void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($administratorsSid, 'FullControl', $inherit, $propagation, $allow)))
  [void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($systemSid, 'FullControl', $inherit, $propagation, $allow)))
  [void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($DeploySid, 'Modify', $inherit, $propagation, $allow)))
  $acl.SetOwner($administratorsSid)
  (New-Object IO.DirectoryInfo($Path)).SetAccessControl($acl)
}

function Set-EunsungSshAcl {
  param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid,
    [switch]$Directory
  )

  $administratorsSid = New-Object Security.Principal.SecurityIdentifier('S-1-5-32-544')
  $systemSid = New-Object Security.Principal.SecurityIdentifier('S-1-5-18')
  if ($Directory) { $acl = New-Object Security.AccessControl.DirectorySecurity } else { $acl = New-Object Security.AccessControl.FileSecurity }
  $acl.SetAccessRuleProtection($true, $false)
  $allow = [Security.AccessControl.AccessControlType]::Allow
  if ($Directory) {
    $inherit = [Security.AccessControl.InheritanceFlags]'ContainerInherit, ObjectInherit'
    $propagation = [Security.AccessControl.PropagationFlags]::None
    [void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($DeploySid, 'FullControl', $inherit, $propagation, $allow)))
    [void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($administratorsSid, 'FullControl', $inherit, $propagation, $allow)))
    [void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($systemSid, 'FullControl', $inherit, $propagation, $allow)))
  } else {
    foreach ($sid in @($DeploySid, $administratorsSid, $systemSid)) {
      [void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($sid, 'FullControl', 'Allow')))
    }
  }
  $acl.SetOwner($DeploySid)
  if($Directory){(New-Object IO.DirectoryInfo($Path)).SetAccessControl($acl)}else{(New-Object IO.FileInfo($Path)).SetAccessControl($acl)}
}

function Set-EunsungBootstrapExecutableAcl {
  param([Parameter(Mandatory)][string]$Path,[Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid)
  $administratorsSid=New-Object Security.Principal.SecurityIdentifier('S-1-5-32-544')
  $systemSid=New-Object Security.Principal.SecurityIdentifier('S-1-5-18')
  $acl=New-Object Security.AccessControl.FileSecurity
  $acl.SetAccessRuleProtection($true,$false)
  [void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($administratorsSid,'FullControl','Allow')))
  [void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($systemSid,'FullControl','Allow')))
  [void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($DeploySid,'ReadAndExecute','Allow')))
  $acl.SetOwner($administratorsSid)
  (New-Object IO.FileInfo($Path)).SetAccessControl($acl)
}

function Set-EunsungProtectedBootstrapDirectoryAcl {
  param([Parameter(Mandatory)][string]$Path,[Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid)
  $administratorsSid=New-Object Security.Principal.SecurityIdentifier('S-1-5-32-544');$systemSid=New-Object Security.Principal.SecurityIdentifier('S-1-5-18')
  $acl=New-Object Security.AccessControl.DirectorySecurity;$acl.SetAccessRuleProtection($true,$false)
  $inherit=[Security.AccessControl.InheritanceFlags]'ContainerInherit, ObjectInherit';$none=[Security.AccessControl.PropagationFlags]::None;$allow=[Security.AccessControl.AccessControlType]::Allow
  foreach($sid in @($administratorsSid,$systemSid)){[void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($sid,'FullControl',$inherit,$none,$allow)))}
  [void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($DeploySid,'ReadAndExecute',$inherit,$none,$allow)))
  $acl.SetOwner($administratorsSid);(New-Object IO.DirectoryInfo($Path)).SetAccessControl($acl)
}

function Assert-EunsungProtectedBootstrapDirectoryAcl {
  param([Parameter(Mandatory)][string]$Path,[Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid)
  Assert-EunsungOrdinaryPath -Path $Path
  $acl=(New-Object IO.DirectoryInfo($Path)).GetAccessControl()
  if(-not $acl.AreAccessRulesProtected){throw 'Protected bootstrap directory ACL inheritance must be disabled.'}
  $owner=([Security.Principal.NTAccount]$acl.Owner).Translate([Security.Principal.SecurityIdentifier]).Value;if($owner -cne 'S-1-5-32-544'){throw 'Protected bootstrap directory owner must be Administrators.'}
  $rules=@($acl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]));if($rules.Count -ne 3){throw 'Protected bootstrap directory ACL must contain exactly three principals.'}
  $deploy=@($rules|Where-Object{$_.IdentityReference.Value -ceq $DeploySid.Value -and $_.AccessControlType -eq 'Allow' -and ($_.FileSystemRights -band 'ReadAndExecute') -eq 'ReadAndExecute' -and ($_.FileSystemRights -band ('Write,Delete,DeleteSubdirectoriesAndFiles')) -eq 0})
  if($deploy.Count -ne 1){throw 'Deployment SID must not write, delete, or replace protected bootstrap files.'}
  $parent=(New-Object IO.DirectoryInfo((Split-Path -Parent $Path))).GetAccessControl();$parentRules=@($parent.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier])|Where-Object{$_.IdentityReference.Value -ceq $DeploySid.Value})
  if(@($parentRules|Where-Object{($_.FileSystemRights -band [Security.AccessControl.FileSystemRights]::DeleteSubdirectoriesAndFiles) -ne 0}).Count -ne 0){throw 'Deployment SID has DeleteChild access through the deployment root.'}
}

function Set-EunsungProtectedBootstrapFile {
  param([Parameter(Mandatory)][string]$BootstrapRoot,[Parameter(Mandatory)][string]$Path,[Parameter(Mandatory)][string]$Content,[Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid)
  $expected=Assert-EunsungBootstrapPath -Root $BootstrapRoot -Candidate $Path
  Assert-EunsungProtectedBootstrapDirectoryAcl -Path $BootstrapRoot -DeploySid $DeploySid
  if(Test-Path -LiteralPath $expected){Assert-EunsungOrdinaryPath -Path $expected;Assert-EunsungBootstrapExecutableAcl -Path $expected -DeploySid $DeploySid}
  $temporary="$expected.$([guid]::NewGuid().ToString('N')).tmp"
  $backup="$expected.$([guid]::NewGuid().ToString('N')).bak"
  try{
    [IO.File]::WriteAllText($temporary,$Content,(New-Object Text.UTF8Encoding($false)));Set-EunsungBootstrapExecutableAcl -Path $temporary -DeploySid $DeploySid;Assert-EunsungOrdinaryPath -Path $temporary;Assert-EunsungBootstrapExecutableAcl -Path $temporary -DeploySid $DeploySid
    if(Test-Path -LiteralPath $expected){[IO.File]::Replace($temporary,$expected,$backup,$true)}else{[IO.File]::Move($temporary,$expected)}
    Assert-EunsungOrdinaryPath -Path $expected;Assert-EunsungBootstrapExecutableAcl -Path $expected -DeploySid $DeploySid
  }finally{
    foreach($cleanup in @($temporary,$backup)){if(Test-Path -LiteralPath $cleanup){Assert-EunsungOrdinaryPath -Path $cleanup;Assert-EunsungBootstrapExecutableAcl -Path $cleanup -DeploySid $DeploySid;Remove-Item -LiteralPath $cleanup -Force}}
  }
}

function Assert-EunsungBootstrapExecutableAcl {
  param([Parameter(Mandatory)][string]$Path,[Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid)
  $acl=(New-Object IO.FileInfo($Path)).GetAccessControl()
  if(-not $acl.AreAccessRulesProtected){throw 'Bootstrap executable ACL inheritance must be disabled.'}
  $owner=([Security.Principal.NTAccount]$acl.Owner).Translate([Security.Principal.SecurityIdentifier]).Value
  if($owner -cne 'S-1-5-32-544'){throw 'Bootstrap executable owner must be Administrators.'}
  $rules=@($acl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]))
  if($rules.Count -ne 3){throw 'Bootstrap executable ACL must contain exactly Administrators, SYSTEM, and the deployment SID.'}
  foreach($sid in @('S-1-5-32-544','S-1-5-18')){if(@($rules|Where-Object{$_.IdentityReference.Value -ceq $sid -and $_.AccessControlType -eq 'Allow' -and ($_.FileSystemRights -band 'FullControl') -eq 'FullControl'}).Count -ne 1){throw 'Bootstrap executable administrative ACL is invalid.'}}
  if(@($rules|Where-Object{$_.IdentityReference.Value -ceq $DeploySid.Value -and $_.AccessControlType -eq 'Allow' -and ($_.FileSystemRights -band 'ReadAndExecute') -eq 'ReadAndExecute' -and ($_.FileSystemRights -band 'Write') -eq 0}).Count -ne 1){throw 'Deployment SID must have read/execute only on bootstrap executables.'}
}

function Get-EunsungRegisteredProfilePath {
  param([Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid,[switch]$AllowMissing,[scriptblock]$RegistryProfileProvider={param($Sid)$entry=Get-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$Sid" -Name ProfileImagePath -ErrorAction SilentlyContinue;if($entry){$entry.ProfileImagePath}})
  $raw=[string](& $RegistryProfileProvider $DeploySid.Value)
  if([string]::IsNullOrWhiteSpace($raw)){if($AllowMissing){return $null};throw 'Windows deployment profile is not registered.'}
  $registered=[IO.Path]::GetFullPath(([Environment]::ExpandEnvironmentVariables($raw))).TrimEnd('\')
  if(-not (Test-Path -LiteralPath $registered -PathType Container)){throw 'Registered Windows deployment profile does not exist.'}
  Assert-EunsungOrdinaryPath -Path $registered
  return $registered
}

function Initialize-EunsungRegisteredProfile {
  param([Parameter(Mandatory)][string]$DeployRoot,[Parameter(Mandatory)][string]$PowerShellPath,[Parameter(Mandatory)][Management.Automation.PSCredential]$Credential,[Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid,[scriptblock]$ProcessStarter={param($StartInfo)Start-Process @StartInfo},[scriptblock]$RegistryProfileProvider={param($Sid)(Get-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$Sid" -Name ProfileImagePath -ErrorAction Stop).ProfileImagePath})
  $outputPath=Assert-EunsungBootstrapPath -Root $DeployRoot -Candidate (Join-Path $DeployRoot ("state\profile-"+[guid]::NewGuid().ToString('N')+'.txt'))
  $preexisting=Get-EunsungRegisteredProfilePath -DeploySid $DeploySid -AllowMissing -RegistryProfileProvider $RegistryProfileProvider
  if($preexisting){return $preexisting}
  $escaped=$outputPath.Replace("'","''")
  $command="[IO.File]::WriteAllText('$escaped',[Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile),(New-Object Text.UTF8Encoding(`$false)))"
  try{
    $process=& $ProcessStarter @{FilePath=$PowerShellPath;ArgumentList="-NoProfile -NonInteractive -ExecutionPolicy Bypass -Command `"$command`"";Credential=$Credential;LoadUserProfile=$true;Wait=$true;PassThru=$true;WindowStyle='Hidden'}
    if($null -eq $process){throw 'Credentialed profile initialization did not return a process result.'}
    if([int]$process.ExitCode -ne 0){
      $registeredAfterFailure=Get-EunsungRegisteredProfilePath -DeploySid $DeploySid -AllowMissing -RegistryProfileProvider $RegistryProfileProvider
      if($registeredAfterFailure){return $registeredAfterFailure}
      throw "Credentialed profile initialization failed with exit code $([int]$process.ExitCode)."
    }
    Assert-EunsungOrdinaryPath -Path $outputPath
    $reported=[IO.Path]::GetFullPath((Get-Content -Raw -LiteralPath $outputPath).Trim()).TrimEnd('\')
    $registered=Get-EunsungRegisteredProfilePath -DeploySid $DeploySid -RegistryProfileProvider $RegistryProfileProvider
    if($reported -ine $registered){throw 'Credentialed profile path does not match the registered Windows profile.'}
    return $registered
  }finally{if(Test-Path -LiteralPath $outputPath){Assert-EunsungOrdinaryPath -Path $outputPath;Remove-Item -LiteralPath $outputPath -Force}}
}

function Assert-EunsungReadExecuteAccess {
  param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid
  )

  $candidateSids = @(
    $DeploySid.Value,
    'S-1-5-32-545',
    'S-1-5-11',
    'S-1-1-0'
  )
  $accessControl=if(Test-Path -LiteralPath $Path -PathType Container){(New-Object IO.DirectoryInfo($Path)).GetAccessControl()}else{(New-Object IO.FileInfo($Path)).GetAccessControl()}
  $rules = $accessControl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier])
  $matching = @($rules | Where-Object { $candidateSids -contains $_.IdentityReference.Value })
  $required = [Security.AccessControl.FileSystemRights]::ReadAndExecute
  $deny = @($matching | Where-Object {
    $_.AccessControlType -eq [Security.AccessControl.AccessControlType]::Deny -and ($_.FileSystemRights -band $required) -ne 0
  })
  $allow = @($matching | Where-Object {
    $_.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow -and ($_.FileSystemRights -band $required) -eq $required
  })
  if ($deny.Count -gt 0 -or $allow.Count -eq 0) {
    throw "The deployment account does not have unambiguous read/execute access to: $Path"
  }
}

function Invoke-EunsungNative {
  param(
    [Parameter(Mandatory)][string]$FilePath,
    [Parameter(Mandatory)][string[]]$Arguments
  )

  & $FilePath @Arguments
  if ($LASTEXITCODE -ne 0) { throw "Native command failed with exit code ${LASTEXITCODE}: $FilePath" }
}

function Get-EunsungWrapperContent {
  param(
    [Parameter(Mandatory)][string]$ProfilePath,
    [Parameter(Mandatory)][string]$Pm2Path
  )

  $escapedProfile = $ProfilePath.Replace("'", "''")
  $escapedPm2 = $Pm2Path.Replace("'", "''")
  return @"
`$ErrorActionPreference = 'Stop'
`$env:USERPROFILE = '$escapedProfile'
`$env:PM2_HOME = Join-Path `$env:USERPROFILE '.pm2'
`$env:Path = (Split-Path -Parent '$escapedPm2') + ';C:\Program Files\nodejs;' + `$env:Path
& '$escapedPm2' resurrect
if (`$LASTEXITCODE -ne 0) { throw "PM2 resurrect failed with exit code `$LASTEXITCODE" }
"@
}

function Test-EunsungScheduledTaskContract {
  param(
    [Parameter(Mandatory)]$Task,
    [Parameter(Mandatory)][string]$WrapperPath,
    [Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid
  )

  if ($Task.TaskName -cne $script:TaskName) { return $false }
  if ([string]$Task.TaskPath -cne $script:TaskPath) { return $false }
  $allowedLocalPrincipals = @(
    $DeploySid.Value,
    ".\$($script:AccountName)",
    "$env:COMPUTERNAME\$($script:AccountName)"
  )
  if ($allowedLocalPrincipals -cnotcontains [string]$Task.Principal.UserId) { return $false }
  if ([string]$Task.Principal.LogonType -ne 'Password') { return $false }
  if ([string]$Task.Principal.RunLevel -ne 'Limited') { return $false }
  $actions = @($Task.Actions)
  if ($actions.Count -ne 1) { return $false }
  $expectedExecutable = [IO.Path]::GetFullPath((Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'))
  $actualExecutable = if ([IO.Path]::IsPathRooted([string]$actions[0].Execute)) {
    [IO.Path]::GetFullPath([string]$actions[0].Execute)
  } else {
    [IO.Path]::GetFullPath((Join-Path $env:SystemRoot "System32\WindowsPowerShell\v1.0\$($actions[0].Execute)"))
  }
  if ($actualExecutable -ine $expectedExecutable) { return $false }
  $expectedArguments = "-NoProfile -NonInteractive -ExecutionPolicy Bypass -File `"$([IO.Path]::GetFullPath($WrapperPath))`""
  if ([string]$actions[0].Arguments -cne $expectedArguments) { return $false }
  $triggers = @($Task.Triggers)
  if ($triggers.Count -ne 1) { return $false }
  return $triggers[0].CimClass.CimClassName -eq 'MSFT_TaskBootTrigger'
}

function Prepare-EunsungResurrectTaskRegistration {
  param(
    [Parameter(Mandatory)][string]$WrapperPath,
    [Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid
  )

  $existing = Get-ScheduledTask -TaskPath $script:TaskPath -TaskName $script:TaskName -ErrorAction SilentlyContinue
  if ($existing -and (Test-EunsungScheduledTaskContract -Task $existing -WrapperPath $WrapperPath -DeploySid $DeploySid)) {
    return $false
  }
  if($existing){throw 'An existing noncompliant deployment task must be handled manually before password rotation.'}
  return $true
}

function Register-EunsungPasswordResurrectTask {
  param([Parameter(Mandatory)][string]$WrapperPath,[Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid,[Parameter(Mandatory)][Security.SecureString]$Password,[scriptblock]$UserSidResolver={param($User)(New-Object Security.Principal.NTAccount($User)).Translate([Security.Principal.SecurityIdentifier])},[scriptblock]$FolderEnsurer={param($TaskPath)$scheduler=New-Object -ComObject 'Schedule.Service';$scheduler.Connect();try{[void]$scheduler.GetFolder($TaskPath)}catch{if($_.Exception.HResult -ne -2147024894){throw};[void]$scheduler.GetFolder('\').CreateFolder('EunsungMES')}},[scriptblock]$TaskRegistrar={param($Parameters)Register-ScheduledTask @Parameters})
  $arguments="-NoProfile -NonInteractive -ExecutionPolicy Bypass -File `"$([IO.Path]::GetFullPath($WrapperPath))`""
  $powershellPath=[IO.Path]::GetFullPath((Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'))
  $taskAction=New-ScheduledTaskAction -Execute $powershellPath -Argument $arguments;$trigger=New-ScheduledTaskTrigger -AtStartup;$settings=New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 2) -StartWhenAvailable
  $user="$env:COMPUTERNAME\$($script:AccountName)";$resolved=& $UserSidResolver $user;if($resolved.Value -cne $DeploySid.Value){throw 'Scheduled task user does not resolve to the exact deployment SID.'}
  & $FolderEnsurer $script:TaskPath
  $bstr=[IntPtr]::Zero;$plain=$null
  try{
    $bstr=[Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password);$plain=[Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    & $TaskRegistrar @{TaskPath=$script:TaskPath;TaskName=$script:TaskName;Action=$taskAction;Trigger=$trigger;Settings=$settings;User=$user;Password=$plain;RunLevel='Limited';Description='Restore Eunsung MES PM2 processes at Windows startup.';Force=$true}|Out-Null
  }finally{$plain=$null;if($bstr -ne [IntPtr]::Zero){[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)}}
}

function Assert-EunsungPm2ProcessOwnership {
  param(
    [Parameter(Mandatory)][object[]]$Processes,
    [Parameter(Mandatory)][string]$Pm2Home,
    [Parameter(Mandatory)][string]$Pm2Path,
    [Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid,
    [scriptblock]$OwnerSidProvider = { param($Process) (Invoke-CimMethod -InputObject $Process -MethodName GetOwnerSid).Sid }
  )

  $pm2HomePattern = [regex]::Escape(([IO.Path]::GetFullPath($Pm2Home).TrimEnd('\')))
  $expectedDaemonPath = Join-Path (Split-Path -Parent $Pm2Path) 'node_modules\pm2\lib\Daemon.js'
  $daemonPattern = [regex]::Escape([IO.Path]::GetFullPath($expectedDaemonPath))
  $matched = @($Processes | Where-Object {
    [string]$_.CommandLine -match "(?i)(?:$pm2HomePattern(?:\\|\b)|$daemonPattern(?:\s|`"|'|$))"
  })
  if ($matched.Count -ne 1) { throw "Expected exactly one deployment-account PM2 daemon, found $($matched.Count)." }
  foreach ($process in $matched) {
    $ownerSid = & $OwnerSidProvider $process
    if ([string]::IsNullOrWhiteSpace([string]$ownerSid) -or [string]$ownerSid -cne $DeploySid.Value) {
      throw "PM2 process $($process.ProcessId) is not owned by the deployment account SID."
    }
  }
  return $matched.Count
}

function Test-EunsungResurrectTask {
  param(
    [Parameter(Mandatory)][string]$Pm2Home,
    [Parameter(Mandatory)][string]$Pm2Path,
    [Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid,
    [int]$MaxAttempts = 20,
    [int]$DelaySeconds = 1
  )

  $previousInfo = Get-ScheduledTaskInfo -TaskPath $script:TaskPath -TaskName $script:TaskName
  $previousLastRunTime = [datetime]$previousInfo.LastRunTime
  $previousLastTaskResult = [int64]$previousInfo.LastTaskResult
  Start-ScheduledTask -TaskPath $script:TaskPath -TaskName $script:TaskName
  try {
    $completedInfo = $null
    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
      $task = Get-ScheduledTask -TaskPath $script:TaskPath -TaskName $script:TaskName
      $currentInfo = Get-ScheduledTaskInfo -TaskPath $script:TaskPath -TaskName $script:TaskName
      $newInvocationObserved = [datetime]$currentInfo.LastRunTime -gt $previousLastRunTime
      if ($newInvocationObserved -and [string]$task.State -ne 'Running') {
        $completedInfo = $currentInfo
        break
      }
      if ($attempt -lt $MaxAttempts) { Start-Sleep -Seconds $DelaySeconds }
    }
    if ($null -eq $completedInfo) {
      throw "A new PM2 resurrect task invocation did not complete within the bounded verification window (previous result $previousLastTaskResult at $previousLastRunTime)."
    }
    if ($completedInfo.LastTaskResult -ne 0) { throw "PM2 resurrect scheduled task failed with result $($completedInfo.LastTaskResult)." }
    $nodeProcesses = @(Get-CimInstance Win32_Process -Filter "Name = 'node.exe'" -ErrorAction SilentlyContinue)
    [void](Assert-EunsungPm2ProcessOwnership -Processes $nodeProcesses -Pm2Home $Pm2Home -Pm2Path $Pm2Path -DeploySid $DeploySid)
  } finally {
    Stop-ScheduledTask -TaskPath $script:TaskPath -TaskName $script:TaskName -ErrorAction SilentlyContinue
  }
}

function Invoke-EunsungBootstrapRollback {
  param([Parameter(Mandatory)][string]$DeployRoot)

  $root = [IO.Path]::GetFullPath($DeployRoot)
  $bootstrapRoot=Assert-EunsungBootstrapPath -Root $root -Candidate (Join-Path $root 'bootstrap')
  $wrapperPath = Assert-EunsungBootstrapPath -Root $bootstrapRoot -Candidate (Join-Path $bootstrapRoot 'Resurrect-EunsungPm2.ps1')
  $helperPath=Assert-EunsungBootstrapPath -Root $bootstrapRoot -Candidate (Join-Path $bootstrapRoot 'Register-EunsungResurrectTask.ps1')
  $task = Get-ScheduledTask -TaskPath $script:TaskPath -TaskName $script:TaskName -ErrorAction SilentlyContinue
  if ($task) { Unregister-ScheduledTask -TaskPath $script:TaskPath -TaskName $script:TaskName -Confirm:$false }
  $account = Get-LocalUser -Name $script:AccountName -ErrorAction SilentlyContinue
  $markerPath = Assert-EunsungBootstrapPath -Root $root -Candidate (Join-Path $root "state\$($script:BootstrapStateFileName)")
  $rollbackSid=if($account){$account.SID}elseif(Test-Path -LiteralPath $markerPath){New-Object Security.Principal.SecurityIdentifier((Get-EunsungBootstrapState -DeployRoot $root -MarkerPath $markerPath).deploySid)}else{$null}
  if ($account) {
    Remove-EunsungOwnedBatchLogonRight -DeployRoot $root -MarkerPath $markerPath -ExpectedDeploySid $account.SID
  } elseif (Test-Path -LiteralPath $markerPath) {
    Remove-EunsungOwnedBatchLogonRight -DeployRoot $root -MarkerPath $markerPath
  }
  if(Test-Path -LiteralPath $bootstrapRoot){
    if(-not $rollbackSid){throw 'Cannot validate protected bootstrap files without the exact deployment SID.'}
    Assert-EunsungProtectedBootstrapDirectoryAcl -Path $bootstrapRoot -DeploySid $rollbackSid
    foreach($protectedFile in @($wrapperPath,$helperPath)){
      if(Test-Path -LiteralPath $protectedFile){Assert-EunsungOrdinaryPath -Path $protectedFile;Assert-EunsungBootstrapExecutableAcl -Path $protectedFile -DeploySid $rollbackSid;$item=Get-Item -LiteralPath $protectedFile -Force;if($item.PSIsContainer){throw "Refusing to remove non-file protected bootstrap path: $protectedFile"};Remove-Item -LiteralPath $protectedFile -Force}
    }
    if(@(Get-ChildItem -LiteralPath $bootstrapRoot -Force).Count -ne 0){throw 'Protected bootstrap directory contains unexpected files.'}
    Remove-Item -LiteralPath $bootstrapRoot -Force
  }
  $scheduler=New-Object -ComObject 'Schedule.Service';$scheduler.Connect();try{$folder=$scheduler.GetFolder($script:TaskPath);if($folder.GetTasks(1).Count -eq 0 -and $folder.GetFolders(0).Count -eq 0){$scheduler.GetFolder('\').DeleteFolder('EunsungMES',0)}}catch{if($_.Exception.HResult -ne -2147024894){throw}}
}

function Initialize-EunsungDeployServer {
  param(
    [Parameter(Mandatory)][string]$PublicKey,
    [Parameter(Mandatory)][string]$DeployRoot,
    [Parameter(Mandatory)][string]$OracleClientLibDir,
    [Parameter(Mandatory)][string]$NodePath,
    [Parameter(Mandatory)][string]$NpmPath
  )

  if ($PublicKey -notmatch '^ssh-ed25519\s+[A-Za-z0-9+/]+={0,3}(?:\s+[^\r\n]+)?$') { throw 'PublicKey must be one complete Ed25519 OpenSSH public key.' }
  if ($PublicKey -match '[\r\n]') { throw 'PublicKey must not contain line breaks.' }
  Assert-EunsungAdministrator

  $password = $null
  $credential = $null
  try {
  $account = Get-LocalUser -Name $script:AccountName -ErrorAction SilentlyContinue
  if (-not $account) {
    $password = New-EunsungRandomPassword
    $account = New-LocalUser -Name $script:AccountName -Password $password -AccountNeverExpires -PasswordNeverExpires -UserMayNotChangePassword -Description 'Eunsung MES deployment account'
  }
  if (-not $account.Enabled) { Enable-LocalUser -Name $script:AccountName }
  $adminGroup = Get-LocalGroup -SID 'S-1-5-32-544'
  $adminMember = Get-LocalGroupMember -Group $adminGroup -ErrorAction Stop | Where-Object { $_.SID -eq $account.SID }
  if ($adminMember) { throw 'The deployment account must not be a member of the local Administrators group.' }

  $root = [IO.Path]::GetFullPath($DeployRoot)
  if (-not (Test-Path -LiteralPath $root)) { New-Item -ItemType Directory -Path $root | Out-Null }
  Assert-EunsungOrdinaryPath -Path $root
  Set-EunsungDirectoryAcl -Path $root -DeploySid $account.SID
  foreach ($directory in @('incoming', 'releases', 'shared', 'logs', 'scripts', 'state')) {
    $path = Assert-EunsungBootstrapPath -Root $root -Candidate (Join-Path $root $directory)
    if (-not (Test-Path -LiteralPath $path)) { New-Item -ItemType Directory -Path $path | Out-Null }
    Assert-EunsungOrdinaryPath -Path $path
    Set-EunsungDirectoryAcl -Path $path -DeploySid $account.SID
  }
  $bootstrapRoot=Assert-EunsungBootstrapPath -Root $root -Candidate (Join-Path $root 'bootstrap')
  if(-not (Test-Path -LiteralPath $bootstrapRoot)){New-Item -ItemType Directory -Path $bootstrapRoot|Out-Null}
  Assert-EunsungOrdinaryPath -Path $bootstrapRoot
  Set-EunsungProtectedBootstrapDirectoryAcl -Path $bootstrapRoot -DeploySid $account.SID
  Assert-EunsungProtectedBootstrapDirectoryAcl -Path $bootstrapRoot -DeploySid $account.SID
  $legacyHelperPath=Assert-EunsungBootstrapPath -Root $bootstrapRoot -Candidate (Join-Path $bootstrapRoot 'Register-EunsungResurrectTask.ps1')
  if(Test-Path -LiteralPath $legacyHelperPath){Assert-EunsungOrdinaryPath -Path $legacyHelperPath;Assert-EunsungBootstrapExecutableAcl -Path $legacyHelperPath -DeploySid $account.SID;Remove-Item -LiteralPath $legacyHelperPath -Force}

  $bootstrapStatePath = Assert-EunsungBootstrapPath -Root $root -Candidate (Join-Path $root "state\$($script:BootstrapStateFileName)")
  Ensure-EunsungBatchLogonRight -DeploySid $account.SID -DeployRoot $root -MarkerPath $bootstrapStatePath
  $wrapperPath = Assert-EunsungBootstrapPath -Root $bootstrapRoot -Candidate (Join-Path $bootstrapRoot 'Resurrect-EunsungPm2.ps1')
  $registrationRequired=Prepare-EunsungResurrectTaskRegistration -WrapperPath $wrapperPath -DeploySid $account.SID
  $powershellPath=[IO.Path]::GetFullPath((Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'))
  if($registrationRequired){
    if(-not $password){$password=New-EunsungRandomPassword;Set-LocalUser -Name $script:AccountName -Password $password}
    $credential=New-Object Management.Automation.PSCredential(".\$($script:AccountName)",$password)
    $profilePath=Get-EunsungRegisteredProfilePath -DeploySid $account.SID -AllowMissing
    if(-not $profilePath){$profilePath=Initialize-EunsungRegisteredProfile -DeployRoot $root -PowerShellPath $powershellPath -Credential $credential -DeploySid $account.SID}
  }else{$profilePath=Get-EunsungRegisteredProfilePath -DeploySid $account.SID}
  $sshPath = Join-Path $profilePath '.ssh'
  $authorizedKeysPath = Join-Path $sshPath 'authorized_keys'
  if (-not (Test-Path -LiteralPath $sshPath)) { New-Item -ItemType Directory -Path $sshPath | Out-Null }
  if (-not (Test-Path -LiteralPath $authorizedKeysPath)) { New-Item -ItemType File -Path $authorizedKeysPath | Out-Null }
  Assert-EunsungOrdinaryPath -Path $sshPath
  Assert-EunsungOrdinaryPath -Path $authorizedKeysPath
  $keys = @(Get-Content -LiteralPath $authorizedKeysPath -ErrorAction Stop)
  if ($keys -cnotcontains $PublicKey) { Add-Content -LiteralPath $authorizedKeysPath -Value $PublicKey -Encoding ASCII }
  Set-EunsungSshAcl -Path $sshPath -DeploySid $account.SID -Directory
  Set-EunsungSshAcl -Path $authorizedKeysPath -DeploySid $account.SID

  foreach ($requiredPath in @($NodePath, $NpmPath, $OracleClientLibDir)) {
    Assert-EunsungOrdinaryPath -Path $requiredPath
    Assert-EunsungReadExecuteAccess -Path $requiredPath -DeploySid $account.SID
  }
  if (-not (Test-Path -LiteralPath $OracleClientLibDir -PathType Container)) { throw 'OracleClientLibDir must be a directory.' }
  $oracleLibrary = Join-Path $OracleClientLibDir 'oci.dll'
  Assert-EunsungOrdinaryPath -Path $oracleLibrary
  Assert-EunsungReadExecuteAccess -Path $oracleLibrary -DeploySid $account.SID
  Invoke-EunsungNative -FilePath $NodePath -Arguments @('--version')

  $npmPrefix = Join-Path $profilePath 'AppData\Roaming\npm'
  if (-not (Test-Path -LiteralPath $npmPrefix)) { New-Item -ItemType Directory -Path $npmPrefix -Force | Out-Null }
  $pnpmPath = Join-Path $npmPrefix 'pnpm.cmd'
  $pm2Path = Join-Path $npmPrefix 'pm2.cmd'
  if (-not (Test-Path -LiteralPath $pnpmPath)) {
    Invoke-EunsungNative -FilePath $NpmPath -Arguments @('install', '--global', '--prefix', $npmPrefix, "pnpm@$($script:PnpmVersion)")
  }
  if (-not (Test-Path -LiteralPath $pm2Path)) {
    Invoke-EunsungNative -FilePath $NpmPath -Arguments @('install', '--global', '--prefix', $npmPrefix, "pm2@$($script:Pm2Version)")
  }
  Set-EunsungDirectoryAcl -Path $npmPrefix -DeploySid $account.SID
  $pnpmActual = (& $pnpmPath --version).Trim()
  if ($LASTEXITCODE -ne 0 -or $pnpmActual -cne $script:PnpmVersion) { throw "Expected pnpm $($script:PnpmVersion), found '$pnpmActual'." }
  $pm2PackagePath = Join-Path $npmPrefix 'node_modules\pm2\package.json'
  Assert-EunsungOrdinaryPath -Path $pm2PackagePath
  $pm2Package = Get-Content -Raw -LiteralPath $pm2PackagePath | ConvertFrom-Json
  $pm2Actual = [string]$pm2Package.version
  if ($pm2Actual -cne $script:Pm2Version) { throw "Expected PM2 $($script:Pm2Version), found '$pm2Actual'." }

  $wrapperContent = Get-EunsungWrapperContent -ProfilePath $profilePath -Pm2Path $pm2Path
  $existingContent = if (Test-Path -LiteralPath $wrapperPath) { Assert-EunsungOrdinaryPath -Path $wrapperPath;Assert-EunsungBootstrapExecutableAcl -Path $wrapperPath -DeploySid $account.SID;Get-Content -Raw -LiteralPath $wrapperPath } else { $null }
  if ($existingContent -cne $wrapperContent) { Set-EunsungProtectedBootstrapFile -BootstrapRoot $bootstrapRoot -Path $wrapperPath -Content $wrapperContent -DeploySid $account.SID }
  Assert-EunsungOrdinaryPath -Path $wrapperPath
  Assert-EunsungBootstrapExecutableAcl -Path $wrapperPath -DeploySid $account.SID
  if($registrationRequired){Register-EunsungPasswordResurrectTask -WrapperPath $wrapperPath -DeploySid $account.SID -Password $password}
  $registeredTask=Get-ScheduledTask -TaskPath $script:TaskPath -TaskName $script:TaskName -ErrorAction Stop
  if(-not (Test-EunsungScheduledTaskContract -Task $registeredTask -WrapperPath $wrapperPath -DeploySid $account.SID)){throw 'Registered scheduled task does not satisfy the exact Password/Limited contract.'}
  Test-EunsungResurrectTask -Pm2Home (Join-Path $profilePath '.pm2') -Pm2Path $pm2Path -DeploySid $account.SID

  Write-Host 'Eunsung deployment server bootstrap completed.'
  } finally {
    if($credential){$credential.Password.Dispose()}elseif($password){$password.Dispose()}
    $credential=$null
    $password=$null
  }
}

if (-not $LibraryOnly) {
  if ([string]::IsNullOrWhiteSpace($DeployRoot)) { throw 'DeployRoot is required.' }
  Assert-EunsungAdministrator
  if ($Action -eq 'Rollback') {
    Invoke-EunsungBootstrapRollback -DeployRoot $DeployRoot
    Write-Host 'Eunsung deployment bootstrap task and wrapper were removed.'
  } else {
    if ([string]::IsNullOrWhiteSpace($PublicKey)) { throw 'PublicKey is required for Initialize.' }
    if ([string]::IsNullOrWhiteSpace($OracleClientLibDir)) { throw 'OracleClientLibDir is required for Initialize.' }
    Initialize-EunsungDeployServer -PublicKey $PublicKey -DeployRoot $DeployRoot -OracleClientLibDir $OracleClientLibDir -NodePath $NodePath -NpmPath $NpmPath
  }
}

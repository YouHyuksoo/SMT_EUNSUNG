$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$script:Passed = 0
$script:Failed = 0

function Test-Case {
  param([string]$Name, [scriptblock]$Body)
  try { & $Body; $script:Passed++; Write-Host "PASS $Name" }
  catch { $script:Failed++; Write-Host "FAIL $Name :: $($_.Exception.Message)" }
}
function Assert-True { param([bool]$Condition, [string]$Message = 'assertion failed') if (-not $Condition) { throw $Message } }
function Assert-Equal { param($Expected, $Actual) if ($Expected -cne $Actual) { throw "expected '$Expected', actual '$Actual'" } }
function Assert-Throws { param([scriptblock]$Body, [string]$Pattern) try { & $Body; throw 'expected exception' } catch { if ($_.Exception.Message -eq 'expected exception' -or $_.Exception.Message -notmatch $Pattern) { throw } } }
function Set-TestProfileAcl {
  param([string]$Path,[Security.Principal.SecurityIdentifier]$DeploySid)
  $acl=New-Object Security.AccessControl.DirectorySecurity;$acl.SetAccessRuleProtection($true,$false)
  $inherit=[Security.AccessControl.InheritanceFlags]'ContainerInherit, ObjectInherit';$none=[Security.AccessControl.PropagationFlags]::None;$allow=[Security.AccessControl.AccessControlType]::Allow
  foreach($sid in @((New-Object Security.Principal.SecurityIdentifier('S-1-5-18')),(New-Object Security.Principal.SecurityIdentifier('S-1-5-32-544')),$DeploySid)){[void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule($sid,'FullControl',$inherit,$none,$allow)))}
  $acl.SetOwner((New-Object Security.Principal.SecurityIdentifier('S-1-5-32-544')))
  (New-Object IO.DirectoryInfo($Path)).SetAccessControl($acl)
}
function New-TestProfileAclVariant {
  param([Security.Principal.SecurityIdentifier]$DeploySid,[string]$Variant)
  $acl=New-Object Security.AccessControl.DirectorySecurity;$acl.SetAccessRuleProtection($true,$false)
  $inherit=[Security.AccessControl.InheritanceFlags]'ContainerInherit, ObjectInherit';$none=[Security.AccessControl.PropagationFlags]::None;$allow=[Security.AccessControl.AccessControlType]::Allow
  $entries=@('S-1-5-18','S-1-5-32-544',$DeploySid.Value)
  if($Variant -eq 'missing-system'){$entries=@($entries|Where-Object{$_ -cne 'S-1-5-18'})}
  if($Variant -eq 'missing-admin'){$entries=@($entries|Where-Object{$_ -cne 'S-1-5-32-544'})}
  if($Variant -eq 'missing-deploy'){$entries=@($entries|Where-Object{$_ -cne $DeploySid.Value})}
  foreach($sid in $entries){[void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule((New-Object Security.Principal.SecurityIdentifier($sid)),'FullControl',$inherit,$none,$allow)))}
  if($Variant -eq 'unrelated-users'){[void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule((New-Object Security.Principal.SecurityIdentifier('S-1-5-32-545')),'FullControl',$inherit,$none,$allow)))}
  if($Variant -eq 'unrelated-everyone-deletechild'){[void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule((New-Object Security.Principal.SecurityIdentifier('S-1-1-0')),'Write, DeleteSubdirectoriesAndFiles',$inherit,$none,$allow)))}
  $owner=if($Variant -eq 'wrong-owner'){[Security.Principal.WindowsIdentity]::GetCurrent().User}else{New-Object Security.Principal.SecurityIdentifier('S-1-5-32-544')}
  $acl.SetOwner($owner);return $acl
}
function Set-TestProfileAclVariant {
  param([string]$Path,[Security.Principal.SecurityIdentifier]$DeploySid,[string]$Variant)
  (New-Object IO.DirectoryInfo($Path)).SetAccessControl((New-TestProfileAclVariant -DeploySid $DeploySid -Variant $Variant))
}

$scriptPath = Join-Path (Split-Path -Parent $PSScriptRoot) 'Initialize-EunsungDeployServer.ps1'
. $scriptPath -LibraryOnly

Test-Case 'path containment rejects prefix confusion' {
  $root = 'D:\Project\SMT_EUNSUNG\.deploy'
  Assert-Equal 'D:\Project\SMT_EUNSUNG\.deploy\scripts\x.ps1' (Assert-EunsungBootstrapPath -Root $root -Candidate "$root\scripts\x.ps1")
  Assert-Throws { Assert-EunsungBootstrapPath -Root $root -Candidate 'D:\Project\SMT_EUNSUNG\.deploy-evil\x.ps1' } 'escapes'
}

Test-Case 'generated password is nonconstant and sufficiently long' {
  $one = New-EunsungRandomPassword
  $two = New-EunsungRandomPassword
  $bstrOne = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($one)
  $bstrTwo = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($two)
  try {
    $plainOne = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstrOne)
    $plainTwo = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstrTwo)
    Assert-True ($plainOne.Length -ge 64)
    Assert-True ($plainOne -cne $plainTwo)
  } finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstrOne)
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstrTwo)
  }
}

Test-Case 'wrapper fixes profile and PM2 home and checks native exit' {
  $content = Get-EunsungWrapperContent -ProfilePath 'C:\Users\eunsung-deploy' -Pm2Path 'C:\Users\eunsung-deploy\AppData\Roaming\npm\pm2.cmd' -LogPath 'D:\deploy\logs\pm2-bootstrap.log'
  Assert-True ($content -match "profileRoot = .*'C:\\Users\\eunsung-deploy'")
  Assert-True ($content -match 'PM2_HOME')
  Assert-True ($content -match "pm2\.cmd' resurrect")
  Assert-True ($content -match '\$nativeExit -ne 0')
  Assert-True ($content -match 'pm2-bootstrap\.log')
  [void][scriptblock]::Create($content)
}

Test-Case 'wrapper pings without dump and resurrects when ordinary dump exists' {
  $testDir=Join-Path ([IO.Path]::GetTempPath()) ("eunsung-wrapper-"+[guid]::NewGuid().ToString('N'));$profile=Join-Path $testDir 'profile';$npm=Join-Path $testDir 'npm';$logs=Join-Path $testDir 'logs';New-Item -ItemType Directory -Path $profile,$npm,$logs|Out-Null
  $pm2=Join-Path $npm 'pm2.cmd';$output=Join-Path $testDir 'operation.txt';$oldProfile=$env:USERPROFILE;$oldPm2=$env:PM2_HOME;$oldPath=$env:Path
  try{
    [IO.File]::WriteAllText($pm2,"@echo off`r`necho %1> `"$output`"`r`nexit /b 0`r`n",[Text.Encoding]::ASCII)
    $wrapper=[scriptblock]::Create((Get-EunsungWrapperContent -ProfilePath $profile -Pm2Path $pm2 -LogPath (Join-Path $logs 'pm2-bootstrap.log')))
    & $wrapper
    Assert-Equal 'ping' ((Get-Content -Raw -LiteralPath $output).Trim())
    $pm2Home=Join-Path $profile '.pm2';New-Item -ItemType Directory -Path $pm2Home -Force|Out-Null;[IO.File]::WriteAllText((Join-Path $pm2Home 'dump.pm2'),'{}')
    & $wrapper
    Assert-Equal 'resurrect' ((Get-Content -Raw -LiteralPath $output).Trim())
  }finally{$env:USERPROFILE=$oldProfile;$env:PM2_HOME=$oldPm2;$env:Path=$oldPath;Remove-Item -LiteralPath $testDir -Recurse -Force}
}

Test-Case 'wrapper rejects unsafe dump path before invoking PM2' {
  $testDir=Join-Path ([IO.Path]::GetTempPath()) ("eunsung-wrapper-"+[guid]::NewGuid().ToString('N'));$profile=Join-Path $testDir 'profile';$npm=Join-Path $testDir 'npm';$logs=Join-Path $testDir 'logs';$pm2Home=Join-Path $profile '.pm2';New-Item -ItemType Directory -Path $pm2Home,$npm,$logs -Force|Out-Null
  $pm2=Join-Path $npm 'pm2.cmd';$output=Join-Path $testDir 'operation.txt';New-Item -ItemType Directory -Path (Join-Path $pm2Home 'dump.pm2')|Out-Null;[IO.File]::WriteAllText($pm2,"@echo off`r`necho invoked> `"$output`"`r`nexit /b 0`r`n",[Text.Encoding]::ASCII)
  try{Assert-Throws { & ([scriptblock]::Create((Get-EunsungWrapperContent -ProfilePath $profile -Pm2Path $pm2 -LogPath (Join-Path $logs 'pm2-bootstrap.log')))) } 'ordinary file';Assert-True (-not (Test-Path -LiteralPath $output))}
  finally{Remove-Item -LiteralPath $testDir -Recurse -Force}
}

Test-Case 'wrapper propagates native ping failure' {
  $testDir=Join-Path ([IO.Path]::GetTempPath()) ("eunsung-wrapper-"+[guid]::NewGuid().ToString('N'));$profile=Join-Path $testDir 'profile';$npm=Join-Path $testDir 'npm';$logs=Join-Path $testDir 'logs';New-Item -ItemType Directory -Path $profile,$npm,$logs|Out-Null;$pm2=Join-Path $npm 'pm2.cmd'
  $long='A'*3000;[IO.File]::WriteAllText($pm2,"@echo off`r`necho token=supersecret $long`r`nexit /b 7`r`n",[Text.Encoding]::ASCII)
  $log=Join-Path $logs 'pm2-bootstrap.log'
  [IO.File]::WriteAllText($log,('X'*70000))
  try{Assert-Throws { & ([scriptblock]::Create((Get-EunsungWrapperContent -ProfilePath $profile -Pm2Path $pm2 -LogPath $log))) } 'PM2 ping failed with exit code 7';$diagnostic=Get-Content -Raw -LiteralPath $log;Assert-True ($diagnostic -match 'status=error stage=invoke operation=ping exit=7 errorClass=NativeExit');Assert-True ($diagnostic -notmatch 'token|supersecret|Bearer|connection|string|\{|\}');Assert-True ($diagnostic.Length -lt 300);$backup="$log.1";Assert-True (Test-Path -LiteralPath $backup);Assert-Equal 70000 (Get-Item -LiteralPath $backup).Length;Assert-Equal 1 @((Get-ChildItem -LiteralPath $logs -Filter 'pm2-bootstrap.log.1')).Count;Assert-True ((Get-EunsungWrapperContent -ProfilePath $profile -Pm2Path $pm2 -LogPath $log) -notmatch '\$pm2Output\s*=\s*@\(')}
  finally{Remove-Item -LiteralPath $testDir -Recurse -Force}
}

Test-Case 'task contract requires exact Password limited startup task' {
  $deploySid = New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1001')
  $powershellPath = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
  $task = [pscustomobject]@{
    TaskName = 'EunsungMES-PM2-Resurrect'
    TaskPath = '\EunsungMES\'
    Principal = [pscustomobject]@{ UserId=$deploySid.Value; LogonType='Password'; RunLevel='Limited' }
    Actions = @([pscustomobject]@{ Execute=$powershellPath; Arguments='-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "D:\deploy\Resurrect-EunsungPm2.ps1"' })
    Triggers = @([pscustomobject]@{ CimClass=[pscustomobject]@{ CimClassName='MSFT_TaskBootTrigger' } })
  }
  Assert-True (Test-EunsungScheduledTaskContract -Task $task -WrapperPath 'D:\deploy\Resurrect-EunsungPm2.ps1' -DeploySid $deploySid)
  $task.Principal.UserId='eunsung-deploy'
  Assert-True (Test-EunsungScheduledTaskContract -Task $task -WrapperPath 'D:\deploy\Resurrect-EunsungPm2.ps1' -DeploySid $deploySid -PrincipalSidResolver {param($UserId)if($UserId -ceq 'eunsung-deploy'){$deploySid}else{throw 'unexpected principal'}})
  $wrongSid=New-Object Security.Principal.SecurityIdentifier('S-1-5-21-9-8-7-1001')
  $task.Principal.UserId='OTHERDOMAIN\eunsung-deploy'
  Assert-True (-not (Test-EunsungScheduledTaskContract -Task $task -WrapperPath 'D:\deploy\Resurrect-EunsungPm2.ps1' -DeploySid $deploySid -PrincipalSidResolver {param($UserId)$wrongSid}))
  $task.Principal.UserId='eunsung-deploy'
  Assert-True (-not (Test-EunsungScheduledTaskContract -Task $task -WrapperPath 'D:\deploy\Resurrect-EunsungPm2.ps1' -DeploySid $deploySid -PrincipalSidResolver {param($UserId)throw 'unresolvable bare collision'}))
  $task.Principal.UserId=$deploySid.Value
  $task.TaskPath='\Wrong\'
  Assert-True (-not (Test-EunsungScheduledTaskContract -Task $task -WrapperPath 'D:\deploy\Resurrect-EunsungPm2.ps1' -DeploySid $deploySid))
  $task.TaskPath='\EunsungMES\'
  $task.Principal.RunLevel = 'Highest'
  Assert-True (-not (Test-EunsungScheduledTaskContract -Task $task -WrapperPath 'D:\deploy\Resurrect-EunsungPm2.ps1' -DeploySid $deploySid))
  $task.Principal.RunLevel = 'Limited'
  $task.Principal.UserId = 'OTHERDOMAIN\eunsung-deploy'
  Assert-True (-not (Test-EunsungScheduledTaskContract -Task $task -WrapperPath 'D:\deploy\Resurrect-EunsungPm2.ps1' -DeploySid $deploySid))
  $task.Principal.UserId = $deploySid.Value
  $task.Actions += [pscustomobject]@{ Execute='cmd.exe'; Arguments='/c whoami' }
  Assert-True (-not (Test-EunsungScheduledTaskContract -Task $task -WrapperPath 'D:\deploy\Resurrect-EunsungPm2.ps1' -DeploySid $deploySid))
  $task.Actions = @($task.Actions[0])
  $task.Triggers += [pscustomobject]@{ CimClass=[pscustomobject]@{ CimClassName='MSFT_TaskTimeTrigger' } }
  Assert-True (-not (Test-EunsungScheduledTaskContract -Task $task -WrapperPath 'D:\deploy\Resurrect-EunsungPm2.ps1' -DeploySid $deploySid))
}

Test-Case 'batch logon right is added once, recorded, and precedes task registration' {
  $deploySid = New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1001')
  $testDir = Join-Path ([IO.Path]::GetTempPath()) ("eunsung-bootstrap-" + [guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Path $testDir | Out-Null
  try {
    New-Item -ItemType Directory -Path (Join-Path $testDir 'state') | Out-Null
    $marker = Join-Path $testDir 'state\bootstrap-state.json'
    $script:hasRight = $false; $script:addCalls = 0; $script:removeCalls = 0
    $manager = @{
      Has = { param($Sid,$Right) Assert-Equal $deploySid.Value $Sid; Assert-Equal 'SeBatchLogonRight' $Right; $script:hasRight }
      Add = { param($Sid,$Right) $script:addCalls++; $script:hasRight = $true }
      Remove = { param($Sid,$Right) $script:removeCalls++; $script:hasRight = $false }
    }
    Ensure-EunsungBatchLogonRight -DeploySid $deploySid -DeployRoot $testDir -MarkerPath $marker -RightManager $manager
    Ensure-EunsungBatchLogonRight -DeploySid $deploySid -DeployRoot $testDir -MarkerPath $marker -RightManager $manager
    Assert-Equal 1 $script:addCalls
    Assert-Equal 0 $script:removeCalls
    $state = Get-Content -Raw -LiteralPath $marker | ConvertFrom-Json
    Assert-Equal $deploySid.Value ([string]$state.deploySid)
    Assert-True ([bool]$state.batchLogonRightAddedByBootstrap)
    $source = Get-Content -Raw -LiteralPath $scriptPath
    Assert-True ($source.LastIndexOf('Ensure-EunsungBatchLogonRight -DeploySid $account.SID') -lt $source.LastIndexOf('Register-EunsungPasswordResurrectTask -WrapperPath $wrapperPath')) 'right grant must precede Password task registration'
  } finally { Remove-Item -LiteralPath $testDir -Recurse -Force }
}

Test-Case 'preexisting batch logon right is recorded as unowned and rollback preserves it' {
  $deploySid = New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1002')
  $testDir = Join-Path ([IO.Path]::GetTempPath()) ("eunsung-bootstrap-" + [guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Path $testDir | Out-Null
  try {
    New-Item -ItemType Directory -Path (Join-Path $testDir 'state') | Out-Null
    $marker = Join-Path $testDir 'state\bootstrap-state.json'
    $script:hasRight = $true; $script:addCalls = 0; $script:removeCalls = 0
    $manager = @{ Has={ $script:hasRight }; Add={ $script:addCalls++ }; Remove={ $script:removeCalls++; $script:hasRight=$false } }
    Ensure-EunsungBatchLogonRight -DeploySid $deploySid -DeployRoot $testDir -MarkerPath $marker -RightManager $manager
    Assert-True (-not [bool]((Get-Content -Raw -LiteralPath $marker | ConvertFrom-Json).batchLogonRightAddedByBootstrap))
    Remove-EunsungOwnedBatchLogonRight -DeployRoot $testDir -MarkerPath $marker -ExpectedDeploySid $deploySid -RightManager $manager
    Assert-Equal 0 $script:addCalls; Assert-Equal 0 $script:removeCalls; Assert-True $script:hasRight
  } finally { Remove-Item -LiteralPath $testDir -Recurse -Force }
}

Test-Case 'rollback removes only an owned batch logon right and partial rerun repairs it' {
  $deploySid = New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1003')
  $testDir = Join-Path ([IO.Path]::GetTempPath()) ("eunsung-bootstrap-" + [guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Path $testDir | Out-Null
  try {
    New-Item -ItemType Directory -Path (Join-Path $testDir 'state') | Out-Null
    $marker = Join-Path $testDir 'state\bootstrap-state.json'
    Set-EunsungBootstrapState -DeployRoot $testDir -MarkerPath $marker -DeploySid $deploySid -Added $true
    $script:hasRight = $false; $script:addCalls = 0; $script:removeCalls = 0
    $manager = @{ Has={ $script:hasRight }; Add={ $script:addCalls++; $script:hasRight=$true }; Remove={ $script:removeCalls++; $script:hasRight=$false } }
    Ensure-EunsungBatchLogonRight -DeploySid $deploySid -DeployRoot $testDir -MarkerPath $marker -RightManager $manager
    Assert-Equal 1 $script:addCalls
    Assert-True ([bool]((Get-Content -Raw -LiteralPath $marker | ConvertFrom-Json).batchLogonRightAddedByBootstrap))
    Remove-EunsungOwnedBatchLogonRight -DeployRoot $testDir -MarkerPath $marker -ExpectedDeploySid $deploySid -RightManager $manager
    Assert-Equal 1 $script:removeCalls; Assert-True (-not $script:hasRight); Assert-True (-not (Test-Path -LiteralPath $marker))
  } finally { Remove-Item -LiteralPath $testDir -Recurse -Force }
}

Test-Case 'batch logon right fails closed when native confirmation fails' {
  $deploySid = New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1004')
  $testDir = Join-Path ([IO.Path]::GetTempPath()) ("eunsung-bootstrap-" + [guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Path $testDir | Out-Null
  try {
    New-Item -ItemType Directory -Path (Join-Path $testDir 'state') | Out-Null
    $marker = Join-Path $testDir 'state\bootstrap-state.json'; $script:checks=0; $script:removes=0
    $manager = @{ Has={ $script:checks++; $false }; Add={}; Remove={ $script:removes++ } }
    Assert-Throws { Ensure-EunsungBatchLogonRight -DeploySid $deploySid -DeployRoot $testDir -MarkerPath $marker -RightManager $manager } 'cleanup=removed'
    Assert-Equal 1 $script:removes
    Assert-True (-not (Test-Path -LiteralPath $marker))
  } finally { Remove-Item -LiteralPath $testDir -Recurse -Force }
}

Test-Case 'bootstrap state rejects schema type tampering and broadened ACLs' {
  $deploySid = New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1005')
  $testDir = Join-Path ([IO.Path]::GetTempPath()) ("eunsung-bootstrap-" + [guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Path (Join-Path $testDir 'state') -Force | Out-Null
  try {
    $marker = Join-Path $testDir 'state\bootstrap-state.json'
    Set-EunsungBootstrapState -DeployRoot $testDir -MarkerPath $marker -DeploySid $deploySid -Added $true
    [IO.File]::WriteAllText($marker,'{"schemaVersion":1,"deploySid":"S-1-5-21-1-2-3-1005","batchLogonRightAddedByBootstrap":"true"}',(New-Object Text.UTF8Encoding($false)))
    Assert-Throws { Get-EunsungBootstrapState -DeployRoot $testDir -MarkerPath $marker } 'types are invalid'
    Set-EunsungBootstrapStateAcl -Path $marker
    $markerInfo=New-Object IO.FileInfo($marker)
    $acl=$markerInfo.GetAccessControl()
    [void]$acl.AddAccessRule((New-Object Security.AccessControl.FileSystemAccessRule((New-Object Security.Principal.SecurityIdentifier('S-1-5-32-545')),'Read','Allow')))
    $markerInfo.SetAccessControl($acl)
    Assert-Throws { Get-EunsungBootstrapState -DeployRoot $testDir -MarkerPath $marker } 'exactly Administrators and SYSTEM'
  } finally { Remove-Item -LiteralPath $testDir -Recurse -Force }
}

Test-Case 'rollback uses protected marker SID when local account is already absent' {
  $deploySid = New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1006')
  $testDir = Join-Path ([IO.Path]::GetTempPath()) ("eunsung-bootstrap-" + [guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Path (Join-Path $testDir 'state') -Force | Out-Null
  try {
    $marker = Join-Path $testDir 'state\bootstrap-state.json'
    Set-EunsungBootstrapState -DeployRoot $testDir -MarkerPath $marker -DeploySid $deploySid -Added $true
    $script:hasRight=$true;$script:removedSid=$null
    $manager=@{Has={$script:hasRight};Add={};Remove={param($Sid,$Right)$script:removedSid=$Sid;$script:hasRight=$false}}
    Remove-EunsungOwnedBatchLogonRight -DeployRoot $testDir -MarkerPath $marker -RightManager $manager
    Assert-Equal $deploySid.Value $script:removedSid
    Assert-True (-not (Test-Path -LiteralPath $marker))
  } finally { Remove-Item -LiteralPath $testDir -Recurse -Force }
}

Test-Case 'password task registration keeps plaintext in-process and uses exact elevated contract' {
  $secure=New-Object Security.SecureString
  foreach($c in 'DoNotLeak!938475'.ToCharArray()){$secure.AppendChar($c)}
  $script:captured=$null
  $sid=New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1007')
  function New-ScheduledTaskAction {[pscustomobject]@{}}
  function New-ScheduledTaskTrigger {[pscustomobject]@{}}
  function New-ScheduledTaskSettingsSet {[pscustomobject]@{}}
  Register-EunsungPasswordResurrectTask -WrapperPath 'D:\deploy\wrapper.ps1' -DeploySid $sid -Password $secure -UserSidResolver {param($User)$sid} -FolderEnsurer {param($TaskPath)Assert-Equal '\EunsungMES' $TaskPath} -TaskRegistrar {param($Parameters)$script:captured=$Parameters}
  Assert-Equal '\EunsungMES\' $script:captured.TaskPath
  Assert-Equal 'Limited' $script:captured.RunLevel
  Assert-True ([bool]$script:captured.Force)
  Assert-Equal 'DoNotLeak!938475' $script:captured.Password
  Assert-True ((Get-Content -Raw -LiteralPath $scriptPath) -notmatch 'ArgumentList[^\r\n]*DoNotLeak')
}

Test-Case 'scheduler cmdlet and COM folder paths remain exact distinct representations' {
  Assert-Equal '\EunsungMES\' $script:TaskPath
  Assert-Equal '\EunsungMES' $script:TaskComFolderPath
  Assert-Throws { Ensure-EunsungScheduledTaskFolder -ComFolderPath '\EunsungMES\' -SchedulerProvider {throw 'provider must not run'} } 'no-trailing-slash'
  $script:createdFolder=$null
  $rootFolder=New-Object PSObject
  Add-Member -InputObject $rootFolder -MemberType ScriptMethod -Name CreateFolder -Value {param($Name)$script:createdFolder=$Name}
  $scheduler=New-Object PSObject
  Add-Member -InputObject $scheduler -MemberType ScriptMethod -Name Connect -Value {}
  Add-Member -InputObject $scheduler -MemberType ScriptMethod -Name GetFolder -Value {param($Path)if($Path -ceq '\'){return $rootFolder};throw (New-Object Runtime.InteropServices.COMException('missing',-2147024894))}
  Ensure-EunsungScheduledTaskFolder -ComFolderPath '\EunsungMES' -SchedulerProvider {$scheduler}
  Assert-Equal 'EunsungMES' $script:createdFolder
}

Test-Case 'scheduler invalid-name HRESULT is never swallowed as a missing folder' {
  $scheduler=New-Object PSObject
  Add-Member -InputObject $scheduler -MemberType ScriptMethod -Name Connect -Value {}
  Add-Member -InputObject $scheduler -MemberType ScriptMethod -Name GetFolder -Value {param($Path)throw (New-Object Runtime.InteropServices.COMException('invalid-name',-2147024773))}
  Assert-Throws { Ensure-EunsungScheduledTaskFolder -ComFolderPath '\EunsungMES' -SchedulerProvider {$scheduler} } 'invalid-name'
}

Test-Case 'helper and wrapper ACL give deployment SID read execute without write' {
  $deploySid=New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1010')
  $testFile=Join-Path ([IO.Path]::GetTempPath()) ("eunsung-helper-"+[guid]::NewGuid().ToString('N')+'.ps1')
  [IO.File]::WriteAllText($testFile,'exit 0')
  try{Set-EunsungBootstrapExecutableAcl -Path $testFile -DeploySid $deploySid;Assert-EunsungBootstrapExecutableAcl -Path $testFile -DeploySid $deploySid}
  finally{Remove-Item -LiteralPath $testFile -Force}
}

Test-Case 'protected bootstrap parent prevents deploy replacement and delete-child access' {
  $deploySid=New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1012')
  $testRoot=Join-Path ([IO.Path]::GetTempPath()) ("eunsung-protected-"+[guid]::NewGuid().ToString('N'))
  $bootstrap=Join-Path $testRoot 'bootstrap'
  New-Item -ItemType Directory -Path $bootstrap -Force|Out-Null
  try{
    Set-EunsungDirectoryAcl -Path $testRoot -DeploySid $deploySid
    Set-EunsungProtectedBootstrapDirectoryAcl -Path $bootstrap -DeploySid $deploySid
    Assert-EunsungProtectedBootstrapDirectoryAcl -Path $bootstrap -DeploySid $deploySid
    Set-EunsungProtectedBootstrapFile -BootstrapRoot $bootstrap -Path (Join-Path $bootstrap 'helper.ps1') -Content 'exit 0' -DeploySid $deploySid
    Assert-EunsungBootstrapExecutableAcl -Path (Join-Path $bootstrap 'helper.ps1') -DeploySid $deploySid
  }finally{Remove-Item -LiteralPath $testRoot -Recurse -Force}
}

Test-Case 'bootstrap path validation rejects hard-linked executable files' {
  $testDir=Join-Path ([IO.Path]::GetTempPath()) ("eunsung-hardlink-"+[guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Path $testDir|Out-Null
  try{
    $target=Join-Path $testDir 'target.ps1';$link=Join-Path $testDir 'helper.ps1'
    [IO.File]::WriteAllText($target,'exit 0')
    New-Item -ItemType HardLink -Path $link -Target $target|Out-Null
    Assert-Throws { Assert-EunsungOrdinaryPath -Path $link } 'Hard links are not allowed'
  }finally{Remove-Item -LiteralPath $testDir -Recurse -Force}
}

Test-Case 'preexisting valid ProfileList path skips credentialed child launch' {
  $deploySid=New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1008')
  $testDir=Join-Path ([IO.Path]::GetTempPath()) ("eunsung-bootstrap-"+[guid]::NewGuid().ToString('N'))
  $profileDir=Join-Path $testDir 'actual-profile'
  New-Item -ItemType Directory -Path (Join-Path $testDir 'state'),$profileDir -Force|Out-Null
  Set-TestProfileAcl -Path $profileDir -DeploySid $deploySid
  try{
    $secure=New-Object Security.SecureString;foreach($c in 'Temp!938475abc'.ToCharArray()){$secure.AppendChar($c)}
    $credential=New-Object Management.Automation.PSCredential('.\eunsung-deploy',$secure)
    $script:startCalls=0
    $starter={param($StartInfo)$script:startCalls++;throw 'credentialed child must be skipped'}
    $resolved=Initialize-EunsungRegisteredProfile -DeployRoot $testDir -PowerShellPath 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -Credential $credential -DeploySid $deploySid -ProcessStarter $starter -RegistryProfileProvider {param($Sid)$profileDir}
    Assert-Equal ([IO.Path]::GetFullPath($profileDir)) $resolved
    Assert-Equal 0 $script:startCalls
    Assert-Equal 0 @((Get-ChildItem -LiteralPath (Join-Path $testDir 'state') -Filter 'profile-*.txt')).Count
  }finally{Remove-Item -LiteralPath $testDir -Recurse -Force}
}

Test-Case 'nonzero credentialed child accepts newly registered valid ProfileList path' {
  $deploySid=New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1013')
  $testDir=Join-Path ([IO.Path]::GetTempPath()) ("eunsung-bootstrap-"+[guid]::NewGuid().ToString('N'))
  $profileDir=Join-Path $testDir 'eunsung-deploy.SERVER'
  New-Item -ItemType Directory -Path (Join-Path $testDir 'state'),$profileDir -Force|Out-Null
  Set-TestProfileAcl -Path $profileDir -DeploySid $deploySid
  try{
    $secure=New-Object Security.SecureString;foreach($c in 'Temp!938475xyz'.ToCharArray()){$secure.AppendChar($c)}
    $credential=New-Object Management.Automation.PSCredential('.\eunsung-deploy',$secure)
    $script:profileRegistered=$false
    $starter={param($StartInfo)$script:profileRegistered=$true;[pscustomobject]@{ExitCode=-1073741502}}
    $provider={param($Sid)if($script:profileRegistered){$profileDir}else{$null}}
    $resolved=Initialize-EunsungRegisteredProfile -DeployRoot $testDir -PowerShellPath 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -Credential $credential -DeploySid $deploySid -ProcessStarter $starter -RegistryProfileProvider $provider
    Assert-Equal ([IO.Path]::GetFullPath($profileDir)) $resolved
    Assert-Equal 0 @((Get-ChildItem -LiteralPath (Join-Path $testDir 'state') -Filter 'profile-*.txt')).Count
  }finally{Remove-Item -LiteralPath $testDir -Recurse -Force}
}

Test-Case 'preexisting ProfileList path rejects owner unrelated ACE and every missing required principal' {
  $deploySid=New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1014')
  $testDir=Join-Path ([IO.Path]::GetTempPath()) ("eunsung-profile-acl-"+[guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Path $testDir|Out-Null
  try{
    foreach($variant in @('wrong-owner','unrelated-users','unrelated-everyone-deletechild','missing-system','missing-admin','missing-deploy')){
      $script:testAcl=New-TestProfileAclVariant -DeploySid $deploySid -Variant $variant
      Assert-Throws { Get-EunsungRegisteredProfilePath -DeploySid $deploySid -RegistryProfileProvider {param($Sid)$testDir} -ProfileAclProvider {param($Path)$script:testAcl} } 'profile (?:owner|ACL)'
    }
  }finally{Set-TestProfileAcl -Path $testDir -DeploySid $deploySid;Remove-Item -LiteralPath $testDir -Recurse -Force}
}

Test-Case 'nonzero child fallback rejects newly registered profile with missing deploy rights' {
  $deploySid=New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1015')
  $testDir=Join-Path ([IO.Path]::GetTempPath()) ("eunsung-profile-fallback-"+[guid]::NewGuid().ToString('N'))
  $profileDir=Join-Path $testDir 'profile';New-Item -ItemType Directory -Path (Join-Path $testDir 'state'),$profileDir -Force|Out-Null
  try{
    Set-TestProfileAclVariant -Path $profileDir -DeploySid $deploySid -Variant 'missing-deploy'
    $secure=New-Object Security.SecureString;foreach($c in 'Temp!938475acl'.ToCharArray()){$secure.AppendChar($c)};$credential=New-Object Management.Automation.PSCredential('.\eunsung-deploy',$secure)
    $script:profileRegistered=$false;$starter={param($StartInfo)$script:profileRegistered=$true;[pscustomobject]@{ExitCode=-1073741502}};$provider={param($Sid)if($script:profileRegistered){$profileDir}else{$null}}
    Assert-Throws { Initialize-EunsungRegisteredProfile -DeployRoot $testDir -PowerShellPath 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -Credential $credential -DeploySid $deploySid -ProcessStarter $starter -RegistryProfileProvider $provider } 'profile ACL'
  }finally{Set-TestProfileAcl -Path $profileDir -DeploySid $deploySid;Remove-Item -LiteralPath $testDir -Recurse -Force}
}

Test-Case 'compliant Password task rerun skips rotation and registration' {
  $deploySid=New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1009')
  $powershellPath=Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
  $script:unregistered=$false
  function Get-ScheduledTask { [pscustomobject]@{TaskName='EunsungMES-PM2-Resurrect';TaskPath='\EunsungMES\';Principal=[pscustomobject]@{UserId=$deploySid.Value;LogonType='Password';RunLevel='Limited'};Actions=@([pscustomobject]@{Execute=$powershellPath;Arguments='-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "D:\deploy\wrapper.ps1"'});Triggers=@([pscustomobject]@{CimClass=[pscustomobject]@{CimClassName='MSFT_TaskBootTrigger'}})} }
  function Unregister-ScheduledTask {$script:unregistered=$true}
  Assert-True (-not (Prepare-EunsungResurrectTaskRegistration -WrapperPath 'D:\deploy\wrapper.ps1' -DeploySid $deploySid))
  Assert-True (-not $script:unregistered)
}

Test-Case 'noncompliant existing task fails before password rotation or replacement' {
  $deploySid=New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1011')
  $script:prior=[pscustomobject]@{TaskName='EunsungMES-PM2-Resurrect';TaskPath='\EunsungMES\';Principal=[pscustomobject]@{UserId=$deploySid.Value;LogonType='Password';RunLevel='Limited'};Actions=@();Triggers=@()}
  $script:unregistered=$false
  function Get-ScheduledTask { $script:prior }
  function Unregister-ScheduledTask {$script:unregistered=$true;$script:prior=$null}
  Assert-Throws { Prepare-EunsungResurrectTaskRegistration -WrapperPath 'D:\deploy\wrapper.ps1' -DeploySid $deploySid } 'handled manually before password rotation'
  Assert-True (-not $script:unregistered)
  Assert-True ($null -ne $script:prior)
}

Test-Case 'PM2 process ownership ignores unrelated legacy PM2 and checks exact deploy SID' {
  $deploySid = New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1001')
  $deployHome = 'C:\Users\eunsung-deploy\.pm2'
  $processes = @(
    [pscustomobject]@{ ProcessId=10; CommandLine='node PM2 daemon (C:\ProgramData\pm2\home)' },
    [pscustomobject]@{ ProcessId=20; CommandLine='node C:\Users\eunsung-deploy\AppData\Roaming\npm\node_modules\pm2\lib\Daemon.js' }
  )
  $pm2Path = 'C:\Users\eunsung-deploy\AppData\Roaming\npm\pm2.cmd'
  $count = Assert-EunsungPm2ProcessOwnership -Processes $processes -Pm2Home $deployHome -Pm2Path $pm2Path -DeploySid $deploySid -OwnerSidProvider { param($Process) if ($Process.ProcessId -eq 20) { $deploySid.Value } else { 'S-1-5-18' } }
  Assert-Equal 1 $count
  Assert-Throws {
    Assert-EunsungPm2ProcessOwnership -Processes $processes -Pm2Home $deployHome -Pm2Path $pm2Path -DeploySid $deploySid -OwnerSidProvider { 'S-1-5-18' }
  } 'deployment account SID'
}

Test-Case 'scheduled task verification observes a fresh completed invocation' {
  $deploySid = New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1001')
  $script:infoCalls = 0
  $script:stopped = $false
  function Get-ScheduledTaskInfo { $script:infoCalls++; if ($script:infoCalls -eq 1) { [pscustomobject]@{LastRunTime=[datetime]'2026-08-31T10:00:00';LastTaskResult=0} } else { [pscustomobject]@{LastRunTime=[datetime]'2026-08-31T10:01:00';LastTaskResult=0} } }
  function Start-ScheduledTask { param($TaskName) }
  function Get-ScheduledTask { [pscustomobject]@{State='Ready'} }
  function Stop-ScheduledTask { $script:stopped = $true }
  function Get-CimInstance { @([pscustomobject]@{ProcessId=20;CommandLine='node C:\Users\eunsung-deploy\AppData\Roaming\npm\node_modules\pm2\lib\Daemon.js'}) }
  function Invoke-CimMethod { [pscustomobject]@{Sid=$deploySid.Value} }
  Test-EunsungResurrectTask -Pm2Home 'C:\Users\eunsung-deploy\.pm2' -Pm2Path 'C:\Users\eunsung-deploy\AppData\Roaming\npm\pm2.cmd' -DeploySid $deploySid -MaxAttempts 2 -DelaySeconds 0
  Assert-True $script:stopped
}

Test-Case 'scheduled task verification rejects a stale prior result' {
  $deploySid = New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1001')
  function Get-ScheduledTaskInfo { [pscustomobject]@{LastRunTime=[datetime]'2026-08-31T10:00:00';LastTaskResult=0} }
  function Start-ScheduledTask { param($TaskName) }
  function Get-ScheduledTask { [pscustomobject]@{State='Ready'} }
  function Stop-ScheduledTask { param($TaskName) }
  Assert-Throws { Test-EunsungResurrectTask -Pm2Home 'C:\Users\eunsung-deploy\.pm2' -Pm2Path 'C:\Users\eunsung-deploy\AppData\Roaming\npm\pm2.cmd' -DeploySid $deploySid -MaxAttempts 2 -DelaySeconds 0 } 'new PM2 resurrect task invocation'
}

Test-Case 'script parses under Windows PowerShell 5.1 AST' {
  $errors = $null
  [void][Management.Automation.Language.Parser]::ParseFile($scriptPath, [ref]$null, [ref]$errors)
  Assert-Equal 0 @($errors).Count
}

Write-Host "RESULT passed=$script:Passed failed=$script:Failed"
if ($script:Failed -gt 0) { exit 1 }

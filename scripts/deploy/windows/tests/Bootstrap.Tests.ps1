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
  $content = Get-EunsungWrapperContent -ProfilePath 'C:\Users\eunsung-deploy' -Pm2Path 'C:\Users\eunsung-deploy\AppData\Roaming\npm\pm2.cmd'
  Assert-True ($content -match "USERPROFILE = 'C:\\Users\\eunsung-deploy'")
  Assert-True ($content -match 'PM2_HOME')
  Assert-True ($content -match "pm2\.cmd' resurrect")
  Assert-True ($content -match '\$LASTEXITCODE -ne 0')
  [void][scriptblock]::Create($content)
}

Test-Case 'task contract requires exact S4U limited startup task' {
  $deploySid = New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1001')
  $powershellPath = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
  $task = [pscustomobject]@{
    TaskName = 'EunsungMES-PM2-Resurrect'
    Principal = [pscustomobject]@{ UserId=$deploySid.Value; LogonType='S4U'; RunLevel='Limited' }
    Actions = @([pscustomobject]@{ Execute=$powershellPath; Arguments='-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "D:\deploy\Resurrect-EunsungPm2.ps1"' })
    Triggers = @([pscustomobject]@{ CimClass=[pscustomobject]@{ CimClassName='MSFT_TaskBootTrigger' } })
  }
  Assert-True (Test-EunsungScheduledTaskContract -Task $task -WrapperPath 'D:\deploy\Resurrect-EunsungPm2.ps1' -DeploySid $deploySid)
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
    Assert-True ($source.LastIndexOf('Ensure-EunsungBatchLogonRight -DeploySid $account.SID') -lt $source.LastIndexOf('Invoke-EunsungCredentialedHelper -PowerShellPath $powershellPath')) 'right grant must precede credentialed task registration'
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

Test-Case 'credentialed helper loads profile without exposing password in process arguments' {
  $secure=New-Object Security.SecureString
  foreach($c in 'DoNotLeak!938475'.ToCharArray()){$secure.AppendChar($c)}
  $credential=New-Object Management.Automation.PSCredential('.\eunsung-deploy',$secure)
  $script:captured=$null
  $starter={param($StartInfo)$script:captured=$StartInfo;[pscustomobject]@{ExitCode=0}}
  Invoke-EunsungCredentialedHelper -PowerShellPath 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -HelperPath 'D:\deploy\helper.ps1' -Action RegisterTask -Credential $credential -WrapperPath 'D:\deploy\wrapper.ps1' -DeploySid (New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1007')) -ProcessStarter $starter
  Assert-True ([bool]$script:captured.LoadUserProfile)
  Assert-True ([bool]$script:captured.Wait)
  Assert-True ($script:captured.Credential -eq $credential)
  Assert-True ([string]$script:captured.ArgumentList -notmatch 'DoNotLeak')
  Assert-True ((Get-EunsungSelfRegistrationHelperContent) -match 'WindowsIdentity.*GetCurrent')
}

Test-Case 'helper and wrapper ACL give deployment SID read execute without write' {
  $deploySid=New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1010')
  $testFile=Join-Path ([IO.Path]::GetTempPath()) ("eunsung-helper-"+[guid]::NewGuid().ToString('N')+'.ps1')
  [IO.File]::WriteAllText($testFile,'exit 0')
  try{Set-EunsungBootstrapExecutableAcl -Path $testFile -DeploySid $deploySid;Assert-EunsungBootstrapExecutableAcl -Path $testFile -DeploySid $deploySid}
  finally{Remove-Item -LiteralPath $testFile -Force}
}

Test-Case 'registered profile is discovered by credentialed launch and checked against ProfileList' {
  $deploySid=New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1008')
  $testDir=Join-Path ([IO.Path]::GetTempPath()) ("eunsung-bootstrap-"+[guid]::NewGuid().ToString('N'))
  $profileDir=Join-Path $testDir 'actual-profile'
  New-Item -ItemType Directory -Path (Join-Path $testDir 'state'),$profileDir -Force|Out-Null
  try{
    $secure=New-Object Security.SecureString;foreach($c in 'Temp!938475abc'.ToCharArray()){$secure.AppendChar($c)}
    $credential=New-Object Management.Automation.PSCredential('.\eunsung-deploy',$secure)
    $starter={param($StartInfo)if($StartInfo.ArgumentList -match '-OutputPath "([^"]+)"'){[IO.File]::WriteAllText($matches[1],$profileDir)}else{throw 'missing output'};[pscustomobject]@{ExitCode=0}}
    $resolved=Resolve-EunsungRegisteredProfilePath -DeployRoot $testDir -PowerShellPath 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -HelperPath (Join-Path $testDir 'helper.ps1') -Credential $credential -DeploySid $deploySid -ProcessStarter $starter -RegistryProfileProvider {param($Sid)$profileDir}
    Assert-Equal ([IO.Path]::GetFullPath($profileDir)) $resolved
    Assert-Equal 0 @((Get-ChildItem -LiteralPath (Join-Path $testDir 'state') -Filter 'profile-*.txt')).Count
  }finally{Remove-Item -LiteralPath $testDir -Recurse -Force}
}

Test-Case 'compliant scheduled task rerun skips self-registration' {
  $deploySid=New-Object Security.Principal.SecurityIdentifier('S-1-5-21-1-2-3-1009')
  $powershellPath=Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
  $script:unregistered=$false
  function Get-ScheduledTask { [pscustomobject]@{TaskName='EunsungMES-PM2-Resurrect';Principal=[pscustomobject]@{UserId=$deploySid.Value;LogonType='S4U';RunLevel='Limited'};Actions=@([pscustomobject]@{Execute=$powershellPath;Arguments='-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "D:\deploy\wrapper.ps1"'});Triggers=@([pscustomobject]@{CimClass=[pscustomobject]@{CimClassName='MSFT_TaskBootTrigger'}})} }
  function Unregister-ScheduledTask {$script:unregistered=$true}
  Assert-True (-not (Prepare-EunsungResurrectTaskRegistration -WrapperPath 'D:\deploy\wrapper.ps1' -DeploySid $deploySid))
  Assert-True (-not $script:unregistered)
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

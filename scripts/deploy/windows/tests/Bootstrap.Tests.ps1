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

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
  $task = [pscustomobject]@{
    TaskName = 'EunsungMES-PM2-Resurrect'
    Principal = [pscustomobject]@{ UserId='.\eunsung-deploy'; LogonType='S4U'; RunLevel='Limited' }
    Actions = @([pscustomobject]@{ Execute='powershell.exe'; Arguments='-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "D:\deploy\Resurrect-EunsungPm2.ps1"' })
    Triggers = @([pscustomobject]@{ CimClass=[pscustomobject]@{ CimClassName='MSFT_TaskBootTrigger' } })
  }
  Assert-True (Test-EunsungScheduledTaskContract -Task $task -WrapperPath 'D:\deploy\Resurrect-EunsungPm2.ps1' -AccountName 'eunsung-deploy')
  $task.Principal.RunLevel = 'Highest'
  Assert-True (-not (Test-EunsungScheduledTaskContract -Task $task -WrapperPath 'D:\deploy\Resurrect-EunsungPm2.ps1' -AccountName 'eunsung-deploy'))
}

Test-Case 'script parses under Windows PowerShell 5.1 AST' {
  $errors = $null
  [void][Management.Automation.Language.Parser]::ParseFile($scriptPath, [ref]$null, [ref]$errors)
  Assert-Equal 0 @($errors).Count
}

Write-Host "RESULT passed=$script:Passed failed=$script:Failed"
if ($script:Failed -gt 0) { exit 1 }

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
$script:PnpmVersion = '10.28.1'
$script:Pm2Version = '6.0.6'

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
  Set-Acl -LiteralPath $Path -AclObject $acl
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
  Set-Acl -LiteralPath $Path -AclObject $acl
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
  $rules = (Get-Acl -LiteralPath $Path).GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier])
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
  $allowedLocalPrincipals = @(
    $DeploySid.Value,
    ".\$($script:AccountName)",
    "$env:COMPUTERNAME\$($script:AccountName)"
  )
  if ($allowedLocalPrincipals -cnotcontains [string]$Task.Principal.UserId) { return $false }
  if ([string]$Task.Principal.LogonType -ne 'S4U') { return $false }
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

function Register-EunsungResurrectTask {
  param(
    [Parameter(Mandatory)][string]$WrapperPath,
    [Parameter(Mandatory)][Security.Principal.SecurityIdentifier]$DeploySid
  )

  $existing = Get-ScheduledTask -TaskName $script:TaskName -ErrorAction SilentlyContinue
  if ($existing -and (Test-EunsungScheduledTaskContract -Task $existing -WrapperPath $WrapperPath -DeploySid $DeploySid)) {
    return $existing
  }
  if ($existing) { Unregister-ScheduledTask -TaskName $script:TaskName -Confirm:$false }

  $arguments = "-NoProfile -NonInteractive -ExecutionPolicy Bypass -File `"$WrapperPath`""
  $powershellPath = [IO.Path]::GetFullPath((Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'))
  $taskAction = New-ScheduledTaskAction -Execute $powershellPath -Argument $arguments
  $trigger = New-ScheduledTaskTrigger -AtStartup
  $principal = New-ScheduledTaskPrincipal -UserId $DeploySid.Value -LogonType S4U -RunLevel Limited
  $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 2) -StartWhenAvailable
  return Register-ScheduledTask -TaskName $script:TaskName -Action $taskAction -Trigger $trigger -Principal $principal -Settings $settings -Description 'Restore Eunsung MES PM2 processes at Windows startup.'
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

  $previousInfo = Get-ScheduledTaskInfo -TaskName $script:TaskName
  $previousLastRunTime = [datetime]$previousInfo.LastRunTime
  $previousLastTaskResult = [int64]$previousInfo.LastTaskResult
  Start-ScheduledTask -TaskName $script:TaskName
  try {
    $completedInfo = $null
    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
      $task = Get-ScheduledTask -TaskName $script:TaskName
      $currentInfo = Get-ScheduledTaskInfo -TaskName $script:TaskName
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
    Stop-ScheduledTask -TaskName $script:TaskName -ErrorAction SilentlyContinue
  }
}

function Invoke-EunsungBootstrapRollback {
  param([Parameter(Mandatory)][string]$DeployRoot)

  $root = [IO.Path]::GetFullPath($DeployRoot)
  $wrapperPath = Assert-EunsungBootstrapPath -Root $root -Candidate (Join-Path $root 'scripts\Resurrect-EunsungPm2.ps1')
  $task = Get-ScheduledTask -TaskName $script:TaskName -ErrorAction SilentlyContinue
  if ($task) { Unregister-ScheduledTask -TaskName $script:TaskName -Confirm:$false }
  if (Test-Path -LiteralPath $wrapperPath) {
    Assert-EunsungOrdinaryPath -Path $wrapperPath
    $item = Get-Item -LiteralPath $wrapperPath -Force
    if ($item.PSIsContainer) { throw "Refusing to remove non-file wrapper path: $wrapperPath" }
    Remove-Item -LiteralPath $wrapperPath -Force
  }
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

  $profilePath = Join-Path $env:SystemDrive "Users\$($script:AccountName)"
  if (-not (Test-Path -LiteralPath $profilePath)) { New-Item -ItemType Directory -Path $profilePath | Out-Null }
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

  $wrapperPath = Assert-EunsungBootstrapPath -Root $root -Candidate (Join-Path $root 'scripts\Resurrect-EunsungPm2.ps1')
  $wrapperContent = Get-EunsungWrapperContent -ProfilePath $profilePath -Pm2Path $pm2Path
  $existingContent = if (Test-Path -LiteralPath $wrapperPath) { Get-Content -Raw -LiteralPath $wrapperPath } else { $null }
  if ($existingContent -cne $wrapperContent) { [IO.File]::WriteAllText($wrapperPath, $wrapperContent, (New-Object Text.UTF8Encoding($false))) }
  Assert-EunsungOrdinaryPath -Path $wrapperPath
  Register-EunsungResurrectTask -WrapperPath $wrapperPath -DeploySid $account.SID | Out-Null
  Test-EunsungResurrectTask -Pm2Home (Join-Path $profilePath '.pm2') -Pm2Path $pm2Path -DeploySid $account.SID

  Write-Host 'Eunsung deployment server bootstrap completed.'
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

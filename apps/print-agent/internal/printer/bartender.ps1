# EUNSUNG Print Agent - BarTender 출력 스크립트
# 사용: powershell -NoProfile -ExecutionPolicy Bypass -File bartender.ps1 <job.json>
# job.json (UTF-8): { template, values: { V1: "..." }, copies, printer, exportPath }
# PB(w_com_bartneder_form_popup)와 같은 순서: 양식 열기 → V1~V20 값 넣기 → 매수만큼 PrintOut → 저장 없이 닫기
#
# BarTender ActiveX 는 형식 정보(type library)를 PowerShell 에 주지 않아 $bt.Formats 같은 속성 접근이 $null 이 된다.
# 그래서 모든 호출을 [System.__ComObject].InvokeMember 로 한다.
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$job = Get-Content -Raw -Encoding UTF8 -LiteralPath $args[0] | ConvertFrom-Json

$com = [System.__ComObject]
$getFlag = [Reflection.BindingFlags]::GetProperty
$setFlag = [Reflection.BindingFlags]::SetProperty
$callFlag = [Reflection.BindingFlags]::InvokeMethod
function Get-ComProperty($target, [string]$name) { return ,$com.InvokeMember($name, $getFlag, $null, $target, $null) }
function Set-ComProperty($target, [string]$name, $value) { [void]$com.InvokeMember($name, $setFlag, $null, $target, @($value)) }
function Invoke-ComMethod($target, [string]$name, [object[]]$arguments) { return ,$com.InvokeMember($name, $callFlag, $null, $target, $arguments) }

$bt = $null
$format = $null
try {
  $bt = New-Object -ComObject BarTender.Application
  Set-ComProperty $bt 'Visible' $false
  $formats = Get-ComProperty $bt 'Formats'
  $format = Invoke-ComMethod $formats 'Open' @([string]$job.template, $false, '')
  foreach ($p in $job.values.PSObject.Properties) {
    $value = [string]$p.Value
    # PB 와 같이 빈 값·NOTFOUND 는 넣지 않는다
    if ($value -eq '' -or $value -eq 'NOTFOUND') { continue }
    try {
      [void](Invoke-ComMethod $format 'SetNamedSubStringValue' @([string]$p.Name, $value))
    } catch {
      throw "양식에 값 칸 $($p.Name) 을(를) 넣지 못했습니다: $($_.Exception.InnerException.Message)"
    }
  }
  if ([string]$job.printer -ne '') { Set-ComProperty $format 'Printer' ([string]$job.printer) }
  $printer = [string](Get-ComProperty $format 'Printer')
  if ([string]$job.exportPath -ne '') {
    # 출력 대신 그림 파일로 내보낸다 (확인용). btColors24Bit=5, 300dpi, btDoNotSaveChanges=1
    [void](Invoke-ComMethod $format 'ExportToFile' @([string]$job.exportPath, 'PNG', 5, 300, 1))
  } else {
    $copies = [int]$job.copies
    if ($copies -lt 1) { $copies = 1 }
    for ($i = 0; $i -lt $copies; $i++) { [void](Invoke-ComMethod $format 'PrintOut' @($false, $false)) }
  }
  Write-Output ('OK|' + $printer)
} catch {
  $message = $_.Exception.Message
  if ($_.Exception.InnerException) { $message = $_.Exception.InnerException.Message }
  [Console]::Error.WriteLine($message)
  exit 1
} finally {
  if ($format -ne $null) { try { [void](Invoke-ComMethod $format 'Close' @(1)) } catch {} }
  if ($bt -ne $null) {
    try { [void](Invoke-ComMethod $bt 'Quit' @(1)) } catch {}
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($bt)
  }
}

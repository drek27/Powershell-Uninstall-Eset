Set-ExecutionPolicy Bypass

Write-Host `
" _____________________________________
|                                     |
|          Delete Script ESET         |
|      Endpoint Security + Agnet      |
|                                     |
| (c) Drek_27                     |
|                                     |
 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯" `
-ForegroundColor Yellow

Write-Host "Make sure to launch the script from the Computer where you need to uninstall software " -ForegroundColor Red
$password = Read-Host "Enter the password for uninstallation of ESET Endpoint Security"

$start = Read-host "You keep them you ? [O] / [N]"
if ( $start -eq 'O' ) {

$namepc = Get-ComputerInfo CsCaption | Select-Object CsCaption 

$uninstall64 = gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "ESET Endpoint Security" } | select UninstallString

if ($uninstall64) {
$uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall64 = $uninstall64.Trim()
Write "Uninstalling..."
start-process "msiexec.exe" -arg "/X $uninstall64 /norestart password=$password" -Wait}


$uninstall64 = gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "ESET Management Agent" } | select UninstallString

if ($uninstall64) {
$uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall64 = $uninstall64.Trim()
Write "Uninstalling..."
start-process "msiexec.exe" -arg "/X $uninstall64 /norestart" -Wait}

Set-NetFirewallProfile -Profile * -Enabled True

Write-Host "Deletion verification process ..."
$namelistappli = Get-WmiObject -Class Win32_Product | Select-Object -Property Name

if ($namelistappli -eq "Eset Management Agent" -and "ESET Endpoint Security" ){
    Write-Host "Eset Endpoint is not deleted" -BackgroundColor Black -ForegroundColor Green
}
else{
    Restart-Computer -ComputerName $namepc
}
}
Else{Write-Host "Bye !"}
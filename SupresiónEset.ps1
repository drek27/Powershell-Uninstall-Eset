Set-ExecutionPolicy Bypass

Write-Host `
" _____________________________________
|                                     |
|        supresi�n Script ESET        |
|      Endpoint Security + Agent      |
|                                     |
| (c) Drek_27                         |
|                                     |
 �������������������������������������" `
-ForegroundColor Yellow

Write-Host "Aseg�rese de iniciar el script desde la computadora donde necesita desinstalar el software " -ForegroundColor Red
$password = Read-Host "Ingrese la contrase�a para la desinstalaci�n de ESET Endpoint Security"

$start = Read-host "Las/Los mantienes t� ? [O] / [N]"
if ( $start -eq 'O' ) {

$uninstall64 = gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "ESET Endpoint Security" } | select UninstallString

if ($uninstall64) {
$uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall64 = $uninstall64.Trim()
Write "Desinstalar..."
start-process "msiexec.exe" -arg "/X $uninstall64 /norestart password=$password" -Wait}


$uninstall64 = gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "ESET Management Agent" } | select UninstallString

if ($uninstall64) {
$uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall64 = $uninstall64.Trim()
Write "Desinstalar..."
start-process "msiexec.exe" -arg "/X $uninstall64 /norestart" -Wait}

Set-NetFirewallProfile -Profile * -Enabled True

Write-Host "Proceso de verificaci�n de eliminaci�n ..."
$namelistappli = Get-WmiObject -Class Win32_Product | Select-Object -Property Name

if ($namelistappli -eq "Eset Management Agent" -and "ESET Endpoint Security" ){
    Write-Host "Eset Endpoint no se borra" -BackgroundColor Black -ForegroundColor Green
}
else{
    Restart-Computer 
}
}
Else{Write-Host "Adios !"}
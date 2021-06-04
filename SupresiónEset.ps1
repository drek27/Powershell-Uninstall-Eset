Set-ExecutionPolicy Bypass

Write-Host `
" _____________________________________
|                                     |
|        supresión Script ESET        |
|      Endpoint Security + Agent      |
|                                     |
| (c) Drek_27                         |
|                                     |
 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯" `
-ForegroundColor Yellow

Write-Host "Asegúrese de iniciar el script desde la computadora donde necesita desinstalar el software " -ForegroundColor Red
$password = Read-Host "Ingrese la contraseña para la desinstalación de ESET Endpoint Security"

$start = Read-host "Las/Los mantienes tú ? [O] / [N]"
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

Write-Host "Proceso de verificación de eliminación ..."
$namelistappli = Get-WmiObject -Class Win32_Product | Select-Object -Property Name

if ($namelistappli -eq "Eset Management Agent" -and "ESET Endpoint Security" ){
    Write-Host "Eset Endpoint no se borra" -BackgroundColor Black -ForegroundColor Green
}
else{
    Restart-Computer 
}
}
Else{Write-Host "Adios !"}
Set-ExecutionPolicy Bypass

Write-Host `
" _____________________________________
|                                     |
|      Script de Suppr�ssion ESET     |
|      Endpoint Security + Agnet      |
|                                     |
| (c) Drek_27                         |
|                                     |
 �������������������������������������" `
-ForegroundColor Yellow

Write-Host "Assurez-vous de bien lancer le script depuis le Poste au quelle vous avez besoin de d�installer un logiciel " -ForegroundColor Red
$password = Read-Host "Entr� le mot de passe pour la d�installation de ESET Endpoint Security"

$start = Read-host "Vous les vous continuer ? [O] / [N]"
if ( $start -eq 'O' ) {

$uninstall64 = gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "ESET Endpoint Security" } | select UninstallString

if ($uninstall64) {
$uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall64 = $uninstall64.Trim()
Write "Suppr�sion..."
start-process "msiexec.exe" -arg "/X $uninstall64 /norestart password=$password" -Wait}


$uninstall64 = gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "ESET Management Agent" } | select UninstallString

if ($uninstall64) {
$uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall64 = $uninstall64.Trim()
Write "Suppr�sion..."
start-process "msiexec.exe" -arg "/X $uninstall64 /norestart" -Wait}

Set-NetFirewallProfile -Profile * -Enabled True

Write-Host "Processus de v�rification de la suppr�ssion ..."
$namelistappli = Get-WmiObject -Class Win32_Product | Select-Object -Property Name

if ($namelistappli -eq "Eset Management Agent" -and "ESET Endpoint Security" ){
    Write-Host "Eset Endpoint n'est pas supprimer" -BackgroundColor Black -ForegroundColor Green
}
else{
    Restart-Computer 
}
}
Else{Write-Host "Bye !"}
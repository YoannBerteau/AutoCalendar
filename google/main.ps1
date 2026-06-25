Import-Module PSGSuite -Force

$P12Path = $env:P12PATH
$RobotEmail = $env:ROBOT_EMAIL
$CalendarId = $env:CALENDARD_ID

Set-PSGSuiteConfig -ConfigName "LinuxBot" -SetAsDefaultConfig -P12KeyPath $P12Path -AppEmail $RobotEmail -AdminEmail $RobotEmail

# Création des objets DateTime
$DateDebut = (Get-Date).Date.AddDays(1).AddHours(14) 
$DateFin = $DateDebut.AddHours(1.5)

# Utilisation de LocalStartDateTime et LocalEndDateTime
$params = @{
    CalendarId         = $CalendarId
    Summary            = "test"
    Description        = "test"
    LocalStartDateTime = $DateDebut
    LocalEndDateTime   = $DateFin
}

try {
    Write-Host "Envoi de la requête à Google..." -ForegroundColor Cyan
    $NouvelEvenement = New-GSCalendarEvent @params -ErrorAction Stop
    Write-Host "Succès ! Événement créé sur la plage horaire avec l'ID : $($NouvelEvenement.Id)" -ForegroundColor Green
}
catch {
    Write-Error "Échec de la création de l'événement : $_"
}
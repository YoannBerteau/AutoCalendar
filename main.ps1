Import-Module PSGSuite -Force

$P12Path = $env:P12PATH
$RobotEmail = $env:ROBOT_EMAIL
$CalendarId = $env:CALENDARD_ID

Set-PSGSuiteConfig -ConfigName "LinuxBot" -SetAsDefaultConfig -P12KeyPath $P12Path -AppEmail $RobotEmail -AdminEmail $RobotEmail

$DateDebut = (Get-Date).Date.AddDays(1).AddHours(14) 
$DateFin = $DateDebut.AddHours(1.5)

$params = @{
    CalendarId  = $CalendarId
    Summary     = "test"
    Description = "test"
    StartDate   = $DateDebut.ToString("s")
    EndDate     = $DateFin.ToString("s")
}

try {
    Write-Host "Envoi de la requête à Google..." -ForegroundColor Cyan
    $NouvelEvenement = New-GSCalendarEvent @params -ErrorAction Stop
    Write-Host "Succès ! Événement créé avec l'ID : $($NouvelEvenement.Id)" -ForegroundColor Green
}
catch {
    Write-Error "Échec de la création de l'événement : $_"
}
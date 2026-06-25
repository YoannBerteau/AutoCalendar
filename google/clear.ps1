Import-Module PSGSuite -Force

$P12Path = $env:P12PATH
$RobotEmail = $env:ROBOT_EMAIL
$CalendarId = $env:CALENDARD_ID

Set-PSGSuiteConfig -ConfigName "LinuxBot" -SetAsDefaultConfig -P12KeyPath $P12Path -AppEmail $RobotEmail -AdminEmail $RobotEmail

$StringDateDebut = "29/06/2026" 
$DateDebutSemaine = [datetime]::ParseExact($StringDateDebut, "dd/MM/yyyy", $null)
$DateFinSemaine = $DateDebutSemaine.AddDays(7) 

try {
    $EvenementsASupprimer = Get-GSCalendarEvent -CalendarId $CalendarId -TimeMin $DateDebutSemaine -TimeMax $DateFinSemaine -ErrorAction Stop

    if ($null -ne $EvenementsASupprimer -and $EvenementsASupprimer.Count -gt 0) {
        foreach ($Event in $EvenementsASupprimer) {
            try {
                Remove-GSCalendarEvent -CalendarId $CalendarId -EventId $Event.Id -ErrorAction Stop
                Write-Host "Événement supprimé avec l'ID : $($Event.Id)" -ForegroundColor Green
            }
            catch {
                Write-Error "Échec de la suppression de l'événement : $_"
            }
        }
    }
}
catch {
    Write-Error "Échec de la récupération des événements : $_"
}
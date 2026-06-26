Import-Module PSGSuite -Force

$P12Path = $env:P12PATH
$RobotEmail = $env:ROBOT_EMAIL
$CalendarId = $env:CALENDARD_ID
$DiscordWebhook = $env:DISCORD_WEBHOOK

Set-PSGSuiteConfig -ConfigName "LinuxBot" -SetAsDefaultConfig -P12KeyPath $P12Path -AppEmail $RobotEmail -AdminEmail $RobotEmail

$json = Get-Content -Path "..\cours.json" -Raw | ConvertFrom-Json
$json_change = Get-Content -Path "..\cours_change.json" -Raw | ConvertFrom-Json

<#

[DateTime]::ParseExact('etc')
Du coup :: sa indique que l'on utilise la métode ParseExact de la classe DateTime

Bien sûr je fais confiance au json, si le json est cassé je peux pas...

Par exemple pour les soutenances, les secrétaires ont mis n'importe quoi :
{

    "Type":"Éval",
    "Ressource":"03/07/2026",
    "Nom_Matiere":null,
    "Heure_debut":"Soutenance",
    "Heure_Fin":null,
    "Prof":"Pas de professeur",
    "Salle":null,
    "Date":"03/07/2026"

},

#>

function sendDiscordWebhook {
    param (
        [string]$WebhookUrl,
        [string]$Message
    )

    $payload = @{
        content = $Message
    } | ConvertTo-Json -Depth 3

    try {
        Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $payload -ContentType 'application/json' | Out-Null
    }
    catch {
        Write-Error "Échec de l'envoi au webhook Discord : $_"
    }
}

function createEvents {
    param (
        [string]$CalendarId,
        [object]$cours
    )

    $salle = "[$($cours.Salle)] "
    if ($cours.Salle) {
        $salle = "[$($cours.Salle)] "
    } else {
        $salle = ""
    }

    $params = @{
        CalendarId         = $CalendarId
        Summary            = "$salle$($cours.Type)"
        Description        = "$($cours.Ressource)<br>$($cours.Prof)"
        Location           = "$($cours.Salle)"
        LocalStartDateTime = [datetime]::ParseExact("$($cours.Date) $($cours.Heure_debut)", "dd/MM/yyyy H\hmm", $null)
        LocalEndDateTime   = [datetime]::ParseExact("$($cours.Date) $($cours.Heure_Fin)", "dd/MM/yyyy H\hmm", $null)
        DisableDefaultReminder = $true
    }

    try {
        $NouvelEvenement = New-GSCalendarEvent @params -ErrorAction Stop
        Write-Host "Cours créé avec l'ID : $($NouvelEvenement.Id)" -ForegroundColor Green
    }
    catch {
        Write-Error "Échec de la création de l'événement : $_"
    }
}

function updateEvents {
    param (
        [string]$CalendarId,
        [string]$EventId,
        [object]$cours,
        [string]$WebhookUrl
    )

    if ($cours.Salle) {
        $salle = "[$($cours.Salle)] "
    } else {
        $salle = ""
    }

    $params = @{
        CalendarId             = $CalendarId
        EventId                = $EventId
        Summary                = "$salle$($cours.Type)"
        Description            = "$($cours.Ressource)<br>$($cours.Prof)"
        Location               = "$($cours.Salle)"
        LocalStartDateTime     = [datetime]::ParseExact("$($cours.Date) $($cours.Heure_debut)", "dd/MM/yyyy H\hmm", $null)
        LocalEndDateTime       = [datetime]::ParseExact("$($cours.Date) $($cours.Heure_Fin)", "dd/MM/yyyy H\hmm", $null)
        DisableDefaultReminder = $true
    }

    try {
        $EvenementMisAJour = Update-GSCalendarEvent @params -ErrorAction Stop
        Write-Host "Cours mis à jour avec l'ID : $($EvenementMisAJour.Id)" -ForegroundColor Green
        
        if ($WebhookUrl) {
            sendDiscordWebhook -WebhookUrl $WebhookUrl -Message "@everyone Le cours $($cours.Type) du $($cours.Date) a été modifié. $($salle)"
        }
    }
    catch {
        Write-Error "Échec de la mise à jour de l'événement : $_"
    }
}

foreach ($cours in $json_change) {
    
    # Ici une petite regex pour éviter les problèmes liés au cas de soutenances
    if ($cours.Date -notmatch "^\d{2}/\d{2}/\d{4}$" -or $cours.Heure_debut -notmatch "\d{1,2}h\d{2}" -or $cours.Heure_Fin -notmatch "\d{1,2}h\d{2}") {
        Write-Host "Ignoré : Données invalides (Date ou Heure) pour le cours $($cours.Type) du $($cours.Date)" -ForegroundColor Yellow
        continue 
    }

    Write-Host "Traitement du cours : $($cours.Type) le $($cours.Date)..." -ForegroundColor Cyan

    $DateRecherche = [datetime]::ParseExact($cours.Date, "dd/MM/yyyy", $null)
    $Lendemain = $DateRecherche.AddDays(1)

    # On check aussi l'heure de début exacte pour éviter d'écraser un cours jumeau (ex: 2 rattrapages le même jour)
    $DateHeureDebutJson = [datetime]::ParseExact("$($cours.Date) $($cours.Heure_debut)", "dd/MM/yyyy H\hmm", $null)

    $EventsDuJour = Get-GSCalendarEvent -CalendarId $CalendarId -TimeMin $DateRecherche -TimeMax $Lendemain

    $EventExistant = $EventsDuJour | Where-Object { $_.Summary -match $cours.Type -and $_.Description -match $cours.Prof -and ([datetime]$_.Start.DateTime) -eq $DateHeureDebutJson } | Select-Object -First 1

    if ($EventExistant) {
        
        if ($cours.Salle) {
            $salle = "[$($cours.Salle)] "
        } else {
            $salle = ""
        }

        $ExpectedSummary = "$salle$($cours.Type)"
        $ExpectedDescription = "$($cours.Ressource)<br>$($cours.Prof)"
        $ExpectedLocation = "$($cours.Salle)"
        $ExpectedEnd = [datetime]::ParseExact("$($cours.Date) $($cours.Heure_Fin)", "dd/MM/yyyy H\hmm", $null)

        if ($EventExistant.Summary -ne $ExpectedSummary -or $EventExistant.Description -ne $ExpectedDescription -or $EventExistant.Location -ne $ExpectedLocation -or ([datetime]$EventExistant.End.DateTime) -ne $ExpectedEnd) {
            Write-Host "  -> Événement existant modifié, on met à jour !"
            updateEvents -CalendarId $CalendarId -EventId $EventExistant.Id -cours $cours -WebhookUrl $DiscordWebhook
        }
    } 
    else {
        Write-Host "  -> Aucun événement correspondant, on le crée !"
        createEvents -CalendarId $CalendarId -cours $cours
    }
}
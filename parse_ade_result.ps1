# On force la console à utiliser l'UTF-8 pour l'affichage des accents
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8

# --- 1. LECTURE DU FICHIER HTML ---
$CheminFichier = "$PWD\ResultADE.html"

if (-not (Test-Path $CheminFichier)) {
    Write-Error "Fichier HTML source introuvable à l'emplacement : $CheminFichier"
    exit
}

# Lecture brute du fichier HTML (Sécurisé en UTF-8)
$CodeSourceHtml = [System.IO.File]::ReadAllText($CheminFichier, [System.Text.Encoding]::UTF8)

# Création du parseur COM
$ParseurHtml = New-Object -ComObject "htmlfile"

# CORRECTION DÉFINITIVE ICI : 
# On transforme le texte en un tableau d'octets (Bytes) pour que le vieux parseur COM l'accepte sans erreur.
$TableauDeBytes = [System.Text.Encoding]::Unicode.GetBytes($CodeSourceHtml)
$ParseurHtml.write($TableauDeBytes)
$ParseurHtml.Close()

# --- 2. RECUPERATION DES DATES DE LA SEMAINE (ID 4 à 16) ---
$datesSemaine = @{}
$increment = 0
for ($dayId = 4; $dayId -le 16; $dayId += 2) {
    $dayDiv = $ParseurHtml.getElementById([string]$dayId)
    if ($null -ne $dayDiv) {
        $text = [string]$dayDiv.innerText
        $text = $text -replace '\s+', ' ' # Nettoyage des espaces
        
        # On isole "Jour dd/mm/yyyy"
        if ($text -match '(\w+)\s+(\d{2}/\d{2}/\d{4})') {
            $datesSemaine[$increment] = "$($Matches[2])"
        } else {
            $datesSemaine[$increment] = $text.Trim()
        }
    } else {
        $datesSemaine[$increment] = "Jour inconnu"
    }
    $increment++
}

# --- 3. EXTRACTEUR DES BLOCS DE COURS ---
$lignesSortie = @()

# Tentative 1 : Récupération classique par ID
$planningDiv = $ParseurHtml.getElementById("Planning")

if ($null -ne $planningDiv) {    
    # On parcourt chaque enfant direct du conteneur Planning
    foreach ($child in $planningDiv.children) {
        # On s'assure qu'on manipule bien une balise DIV
        if ($child.tagName -ne "DIV") { continue }

        # Récupération de la position "left" sur ce conteneur parent pour trouver le jour
        $leftVal = 0
        $styleAttr = $child.style.cssText
        
        if ($null -ne $styleAttr -and $styleAttr -match 'left\s*:\s*(\d+)px') {
            $leftVal = [int]$Matches[1]
        }
        
        # Calcul de l'index du jour (0 = Lundi, 1 = Mardi, etc.)
        $dayIndex = [Math]::Round($leftVal / 185)
        if ($dayIndex -lt 0) { $dayIndex = 0 }
        if ($dayIndex -gt 6) { $dayIndex = 6 }
        $jourCours = $datesSemaine[[int]$dayIndex]

        # On cherche la sous-div "innerX" à l'intérieur de ce bloc parent
        $subDivs = $child.getElementsByTagName("div")
        $divInner = $null
        foreach ($subDiv in $subDivs) {
            if ($subDiv.id -match '^inner\d+$') {
                $divInner = $subDiv
                break
            }
        }

        # Si on a trouvé la div interne contenant les informations du cours
        if ($null -ne $divInner) {
            $rawText = [string]$divInner.innerText
            
            # Découpage par ligne en ignorant les lignes vides
            $lines = $rawText -split '\r?\n' | Where-Object { $_ -match '\S' }
            
            if ($lines.Count -gt 0) {                
                # On ajoute ensuite les lignes d'origine du cours
                foreach ($l in $lines) {
                    $lignesSortie += $l.Trim()
                }

                # On injecte le jour calculé comme TOUTE PREMIÈRE ligne de ce bloc
                $lignesSortie += $jourCours
            }
        }
    }
} else {
    Write-Error "ERREUR : Impossible de localiser le conteneur principal 'Planning' (ID ou Classe)."
    exit
}

# --- 4. ENREGISTREMENT ET NETTOYAGE ---
# Utilisation de .NET pour forcer un UTF-8 parfait sans aucun bug d'accents
[System.IO.File]::WriteAllLines("$PWD\ParsedADE.txt", $lignesSortie, [System.Text.Encoding]::UTF8)

# Suppression du fichier HTML d'origine
if (Test-Path $CheminFichier) {
    Remove-Item -Path $CheminFichier -Force
}
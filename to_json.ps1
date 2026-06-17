# On lit le fichier texte sans les lignes vides
$lignes = Get-Content -Path ".\ParsedADE.txt" -Encoding UTF8 | Where-Object { $_ -match '\S' }
$len = $lignes.count

# On crée un tableau vide qui va stocker tous nos cours
$coursArray = @()

$i = 0
while($i -lt $len){
    # ASTUCE : Le fait d'ajouter [string] "nettoie" la ligne de toutes les métadonnées (PSPath, etc.)
    # pour en faire un texte brut parfait.
    $lignes0 = [string]$lignes[$i]
    $increment = 3
    
    # Sécurité : Si on arrive à la fin et qu'il manque la ligne d'heure, on arrête
    if (($i + 1) -ge $len) { break }
    $lignes1 = [string]$lignes[$i + 1]

    # --- 1. PARSING DE LA LIGNE TITRE (lignes0) ---
    $infosLigne0 = $lignes0 -split " - "
    
    if ($infosLigne0[0] -match "\d"){
        $type = "Éval"
        $res = $infosLigne0[0]
        $nom = $infosLigne0[1]
    } 
    # CORRECTION : Utilisation de -match au lieu de la syntaxe invalide -in avec virgule
    elseif ($infosLigne0[0] -match "union"){
        $type = ($infosLigne0[0] -split " ")[0]
        $res = "Pas de ressource"
        $nom = ($infosLigne0[0] -split " ")[1]
    } 
    elseif ($infosLigne0[0] -match "Rattrapages"){
        $type = ($infosLigne0[0] -split " ")[0]
        $res = "Pas de ressource"
        $nom = "Pas de nom"
        $increment = 2 # On n'a pas de ligne prof pour les rattrapages
    }
    else {
        $type = $infosLigne0[0]
        $res = $infosLigne0[1]
        $nom = $infosLigne0[2]
        if ($type -eq "NE") {
            $increment = 2 # On n'a pas de ligne prof pour les NET
        }
        if ($nom -match "(.val)"){
            $type = "Éval"
        }
    }

    # --- 2. PARSING DE LA LIGNE HORAIRE (lignes1) ---
    $infosLigne1 = $lignes1 -split " "
    $heure_debut = $infosLigne1[0]
    $heure_fin = $infosLigne1[2]
    $salle = $infosLigne1[3]

    # --- 3. PARSING DE LA LIGNE PROF (lignes2 Optionnelle) ---
    $prof = "Pas de professeur"

    # On s'assure qu'on ne déborde pas du fichier avant de lire la 3ème ligne

    if ($increment -eq 2) {
        $prof = "Pas de professeur"
    }
    else {
        if (($i + 2) -lt $len) {
            $lignes2 = [string]$lignes[$i + 2] # Nettoyage en texte brut
            $premierMot = ($lignes2 -split '\s+')[0]
            
            # On utilise notre fameuse regex robuste pour les majuscules
            if ($premierMot -cmatch "^[\p{Lu}\-]+$"){
                $prof = $lignes2 # Maintenant $lignes2 est un vrai texte propre
            }
        }
    }

    # --- 4. CREATION ET AJOUT DE L'OBJET ---
    # On crée un objet PowerShell propre (beaucoup mieux que de créer une string JSON à la main)
    $coursObj = [PSCustomObject]@{
        Type        = $type
        Ressource   = $res
        Nom_Matiere = $nom
        Heure_debut = $heure_debut
        Heure_Fin   = $heure_fin
        Prof        = $prof
        Salle       = $salle
    }
    
    # On ajoute ce cours à notre liste
    $coursArray += $coursObj

    # On avance l'index de 2 ou 3 selon si on a trouvé un prof
    $i += $increment
}

# --- 5. EXPORT FINAL EN JSON ---
# ConvertTo-Json s'occupe de tout (les accolades, les virgules, les tableaux)
# Le paramètre -Depth 3 empêche PowerShell de tronquer les données complexes
$json = $coursArray | ConvertTo-Json -Compress -Depth 3
$json = $json.Replace("\u0027", "'")
$json | Out-File -FilePath ".\cours.json" -Encoding UTF8

Remove-Item -Path ".\ParsedADE.txt"
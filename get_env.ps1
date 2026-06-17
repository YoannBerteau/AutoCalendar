# 1. Chemin vers votre fichier .env (à adapter si besoin)
$CheminEnv = "$PWD\.env"

# 2. On vérifie que le fichier existe
if (Test-Path $CheminEnv) {    
    # 3. On lit le fichier ligne par ligne
    Get-Content $CheminEnv | Where-Object {
        # On ignore les lignes vides et les commentaires (lignes commençant par #)
        ![string]::IsNullOrWhiteSpace($_) -and -not $_.TrimStart().StartsWith('#')
    } | ForEach-Object {
        # 4. L'ASTUCE : On coupe la ligne au niveau du PREMIER '=' uniquement
        # (Très important car votre URL peut contenir des paramètres comme ?id=1)
        $nom, $valeur = $_ -split '=', 2
        
        # On nettoie les espaces inutiles et les éventuels guillemets
        $nom = $nom.Trim()
        $valeur = $valeur.Trim().Trim('"', "'")
        
        # 5. On injecte la variable dans l'environnement de la session actuelle
        Set-Item -Path "Env:$nom" -Value $valeur
    }
} else {
    Write-Warning "Fichier .env introuvable à l'emplacement : $CheminEnv"
}
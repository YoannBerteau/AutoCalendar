[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8

# 1. On lit tout le contenu du fichier HTML sauvegardé
# (Pensez à adapter le chemin vers votre vrai fichier)
$CheminFichier = ".\ResultADE.html"
$CodeSourceHtml = Get-Content -Path $CheminFichier -Raw -Encoding UTF8

# 2. On charge ce code source dans un vrai parseur HTML en mémoire (sans ouvrir de navigateur)
$ParseurHtml = New-Object -ComObject "htmlfile"
$ParseurHtml.IHTMLDocument2_write($CodeSourceHtml)
$ParseurHtml.Close()

# 3. Initialisation des variables
$x = 0
$mesCours = @()

Write-Host "Début du parsing du fichier..."

# 4. La boucle de récupération
while ($true) {

    $divInner = $ParseurHtml.getElementById("inner$x")

    if ($null -eq $divInner) {
        Write-Host " -> div$x non trouvée. Fin de la boucle."
        break
    }

    $contenu = $divInner.innerText
    $mesCours += $contenu

    Write-Host " -> div$x extraite avec succès."
    
    # On passe au x suivant
    $x++
}

# --- Résultat ---
Write-Host "Terminé. Nous avons récupéré $x éléments au total."

# Pour afficher le tout premier élément trouvé par exemple :
Add-Content -Path "ParsedADE.txt" -Value $mesCours
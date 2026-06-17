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

# 4. La boucle de récupération
while ($true) {

    $divInner = $ParseurHtml.getElementById("inner$x")

    if ($null -eq $divInner) {
        break
    }

    $contenu = $divInner.innerText
    $mesCours += $contenu
    
    # On passe au x suivant
    $x++
}

# Pour afficher le tout premier élément trouvé par exemple :
$mesCours | Out-File -FilePath "ParsedADE.txt" -Encoding UTF8
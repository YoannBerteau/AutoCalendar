# On définit le chemin complet vers votre dossier "driver_firefox"
# $PWD correspond au dossier actuel où s'exécute le script
$CheminGecko = "$PWD\driver_firefox"

# On ajoute ce dossier au PATH pour la durée d'exécution du script
$env:PATH += ";$CheminGecko"

$url = "URL_PLANNING_MASQUEE"

# Charge le module dans la session active
Import-Module -Name Selenium

# On lance Firefox au lieu de Chrome (le paramètre -Quiet permet de le lancer en arrière-plan)
$driver = Start-SeFirefox -Quiet

# On va sur l'URL
Enter-SeUrl -Driver $driver -Url $url

# On attend que la page charge
Start-Sleep -Seconds 3

# On récupère le code
$codeSource = $driver.PageSource

# On ferme le navigateur
Stop-SeDriver -Driver $driver

Add-Content -Path "ResultADE.txt" -Value $codeSource
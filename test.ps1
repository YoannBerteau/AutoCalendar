$url = "URL_PLANNING_MASQUEE"

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

Write-Output $codeSource
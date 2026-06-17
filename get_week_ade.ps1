# On définit le chemin complet vers votre dossier "driver_firefox"
# $PWD correspond au dossier actuel où s'exécute le script
$CheminGecko = "$PWD\driver_firefox"

# On ajoute ce dossier au PATH pour la durée d'exécution du script
$env:PATH += ";$CheminGecko"

$url = $env:URL

# Charge le module dans la session active
Import-Module -Name Selenium

# 1. On crée les options avancées pour Firefox
$options = New-Object OpenQA.Selenium.Firefox.FirefoxOptions

# On active le mode headless manuellement
$options.AddArgument("--headless")

# On force une résolution classique d'ordinateur de bureau
$options.AddArgument("--window-size=1920,1080")

# On falsifie le User-Agent pour ressembler à un Firefox tout à fait normal sous Windows
$options.SetPreference("general.useragent.override", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0")

# 2. On lance Firefox avec nos options personnalisées
$driver = New-Object OpenQA.Selenium.Firefox.FirefoxDriver($options)

# 3. On exécute la navigation
$driver.Navigate().GoToUrl($url)

# On laisse un peu plus de temps en headless (le rendu sans GPU peut être plus lent)
Start-Sleep -Seconds 5 

$codeSource = $driver.PageSource

# On ferme proprement
$driver.Quit()

$codeSource | Out-File -FilePath "ResultADE.html" -Encoding UTF8
# Librairies
Add-Type -AssemblyName System.Windows.Forms # Pour la création d'interface
Add-Type -AssemblyName System.Drawing # Pour les éléments graphique

# Création et configuration de la fenêtre d'interface
$form = New-Object System.Windows.Forms.Form
$form.Text = "Auto-Calendar email link process" # Titre de la fenêtre
$form.Size = New-Object System.Drawing.Size(300,200) # Taille de la fenêtre lors de son ouverture
$form.StartPosition = 'CenterScreen' # Ouverture de la fenêtre au centre de notre écran
$form.BackColor = 'white' # Couleur du fond de la fenêtre

# Création et configuration du bouton de validation
$ValButton = New-Object System.Windows.Forms.Button
$ValButton.Location = New-Object System.Drawing.Point(75,120) # Position du bouton dans la fenêtre
$ValButton.Size = New-Object System.Drawing.Size(75,23) # Taille du bouton
$ValButton.Text = 'Validate' # Texte à l'intérieur du bouton
$form.AcceptButton = $ValButton # Défini ce bouton comme bouton de validation par défaut (appelé lorsqu'on appuie sur 'entrée')
$form.Controls.Add($ValButton) # Ajout de l'élément à l'interface créée précédemment

# Création et configuration du bouton d'arrêt
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120) # Position du bouton dans la fenêtre
$cancelButton.Size = New-Object System.Drawing.Size(75,23) # Taille du bouton
$cancelButton.Text = 'Cancel' # Texte à l'intérieur du bouton
$form.CancelButton = $cancelButton # Défini ce bouton comme bouton d'arrêt par défaut (appelé lorsqu'on appuie sur 'échap')
$form.Controls.Add($cancelButton) # Ajout de l'élément à l'interface créée précédemment

# Création et configuration du texte explicatif
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20) # Position du texte dans la fenêtre
$label.Size = New-Object System.Drawing.Size(280,40) # Taille du texte explicatif
$label.Text = 'In order to use Auto-Calendar you first need to provide an email.
Please enter the information in the space below:' # Contenu du texte
$form.Controls.Add($label) # Ajout de l'élément à l'interface créée précédemment

# Création et configuration d'une zone de texte pour le user
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,60) # Position de la zone de texte dans la fenêtre
$textBox.Size = New-Object System.Drawing.Size(260,20) # Taille de la zone de texte
$form.Controls.Add($textBox) # Ajout de l'élément à l'interface créée précédemment

# Création et configuration du texte informatif d'erreur/évènement
$eventLabel = New-Object System.Windows.Forms.Label
$eventLabel.Location = New-Object System.Drawing.Point(10,80) # Position du texte dans la fenêtre
$eventLabel.AutoSize = $true # Activation de la taille automatique (car contenu à longueur variable)
$form.Controls.Add($eventLabel) # Ajout de l'élément à l'interface créée précédemment

$form.Topmost = $true # Force la fenêtre à être au premier plan

$form.Add_Shown({$textBox.Select()}) # Séléctionne par défaut la zone de texte pour faciliter la saisie du user

# Fonction de test du format de l'email saisi grâce à la fonction comparaison 'match' (prend une variable String en entrée)
function emailFormat{
    param([string]$email)
    return $email -match '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9._%+-]+\.[a-zA-Z]{2,}$'
}

# Défini les évènement
$ValButton.Add_Click({
    $email = $textBox.Text # Récupération de la saisie utilisateur
    if (emailFormat -email $email){
        # Réponse coté console
        Write-Host "Valid email format !" -ForegroundColor Green
        Write-Host $email

        # Réponse coté utilisateur
        $eventLabel.Text = 'Valid email !'
        $eventLabel.ForeColor = "Green"

        # Auto stop avec du temps pour que le user puisse lire la réponse
        Start-Sleep -Seconds 1
        $form.Close()
    }else{
        # Réponse coté console
        Write-Host "Invalid email format" -ForegroundColor Red

        # Réponse coté utilisateur
        $eventLabel.Text = 'Invalid email'
        $eventLabel.ForeColor = "Red"
    }
})

$form.ShowDialog() | Out-Null # Affichage de l'interface (Out-Null pour ne pas avoir la réponse 'cancel' dans la console fermeture)
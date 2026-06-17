Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Start-Process chrome.exe '--new-window https://calendar.google.com/calendar/u/0/r/settings/addbyurl?pli=1'

# Création et configuration de la fenêtre d'interface
$size = New-Object System.Drawing.Size(300,620)
$stepsForm = New-Object System.Windows.Forms.Form
$stepsForm.Text = "Auto-Calendar Setup" # Titre de la fenêtre
$stepsForm.Size = $size # Taille de la fenêtre lors de son ouverture
$stepsForm.StartPosition = 'CenterScreen' # Ouverture de la fenêtre au centre de notre écran
$stepsForm.BackColor = 'white' # Couleur du fond de la fenêtre
$stepsForm.MaximumSize = $size
$stepsForm.MinimumSize = $size

# Création et configuration du bouton d'arrêt
$OkButton = New-Object System.Windows.Forms.Button
$OkButton.Location = New-Object System.Drawing.Point(115,540) # Position du bouton dans la fenêtre
$OkButton.Size = New-Object System.Drawing.Size(60,30) # Taille du bouton
$OkButton.Text = 'Ok' # Texte à l'intérieur du bouton
$stepsForm.CancelButton = $OkButton # Défini ce bouton comme bouton d'arrêt par défaut (appelé lorsqu'on appuie sur 'échap')
$stepsForm.Controls.Add($OkButton) # Ajout de l'élément à l'interface créée précédemment

# Création et configuration du bouton pour copier dans le presse-papiers
$urlCopyButton = New-Object System.Windows.Forms.Button
$urlCopyButton.Location = New-Object System.Drawing.Point(230,20) # Position du bouton dans la fenêtre
$urlCopyButton.Size = New-Object System.Drawing.Size(50,30) # Taille du bouton
$urlCopyButton.Text = 'Copy' # Texte à l'intérieur du bouton
$stepsForm.Controls.Add($urlCopyButton) # Ajout de l'élément à l'interface créée précédemment

# Création et configuration du texte de l'url à copier dans le presse-papiers
$urlLabel = New-Object System.Windows.Forms.Label
$urlLabel.Location = New-Object System.Drawing.Point(10,10) # Position du texte dans la fenêtre
$urlLabel.Size = New-Object System.Drawing.Size(220,40) # Taille du text de l'URL
$urlLabel.Text ="Calendar link : https://calendar.google.com/calendar/ical/rtplanner%40proton.me/private-3fc1a5ca56d615fdc72396f1aefaddf8/basic.ics"
$urlLabel.ForeColor = "Gray"
$stepsForm.Controls.Add($urlLabel)

# Création et configuration du texte de l'url à copier dans le presse-papiers
$warnLabel = New-Object System.Windows.Forms.Label
$warnLabel.Location = New-Object System.Drawing.Point(10,60) # Position du texte dans la fenêtre
$warnLabel.Size = New-Object System.Drawing.Size(270,25) # Taille du text de l'URL
$warnLabel.Text ="!!! Before continuing, do not publicly disclose this URL by no means !!!"
$warnLabel.ForeColor = "Red"
$stepsForm.Controls.Add($warnLabel)

# Création et configuration du texte explicatif
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,95) # Position du texte dans la fenêtre
$label.Size = New-Object System.Drawing.Size(270,465) # Taille du texte explicatif
$label.Text = 'Add a Calendar via URL in Google Calendar

You are about to add an external calendar using a web link (URL).
This will automatically import events from that calendar into your Google Calendar.

Step 1 — Sign in (if required)

If you are not already signed in, log in to your Google account.

Step 2 — Locate the “calendar URL” text field

Paste the calendar link (URL) you have been provided (usually ending in .ics).

Step 3 — Add the calendar

Click the button:
“Add calendar”

Step 4 — Confirmation

The calendar will now appear under “Other calendars”.

It may take a few moments to load events.

Important notes : 
This calendar is read-only (you cannot edit events unless you own the calendar).
Updates from the external calendar may take some time to sync automatically.' # Contenu du texte

$stepsForm.Controls.Add($label) # Ajout de l'élément à l'interface créée précédemment

$stepsForm.Topmost = $true # Force la fenêtre à être au premier plan

$urlCopyButton.Add_Click({
    Set-Clipboard -Value "https://calendar.google.com/calendar/ical/rtplanner%40proton.me/private-3fc1a5ca56d615fdc72396f1aefaddf8/basic.ics" -ErrorAction SilentlyContinue
    $urlCopyButton.Text = "Copied"
    $urlCopyButton.ForeColor = "Green"

})

$stepsForm.ShowDialog() | Out-Null # Affichage de l'interface (Out-Null pour ne pas avoir la réponse 'cancel' dans la console fermeture)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Start-Process 'https://calendar.google.com/calendar/u/0/r/settings/addbyurl?pli=1'

# Création et configuration de la fenêtre d'interface
$stepsForm = New-Object System.Windows.Forms.Form
$stepsForm.Text = "Auto-Calendar Setup" # Titre de la fenêtre
$stepsForm.Size = New-Object System.Drawing.Size(300,540) # Taille de la fenêtre lors de son ouverture
$stepsForm.StartPosition = 'CenterScreen' # Ouverture de la fenêtre au centre de notre écran
$stepsForm.BackColor = 'white' # Couleur du fond de la fenêtre

# Création et configuration du bouton d'arrêt
$OkButton = New-Object System.Windows.Forms.Button
$OkButton.Location = New-Object System.Drawing.Point(115,460) # Position du bouton dans la fenêtre
$OkButton.Size = New-Object System.Drawing.Size(60,30) # Taille du bouton
$OkButton.Text = 'Ok' # Texte à l'intérieur du bouton
$stepsForm.CancelButton = $OkButton # Défini ce bouton comme bouton d'arrêt par défaut (appelé lorsqu'on appuie sur 'échap')
$stepsForm.Controls.Add($OkButton) # Ajout de l'élément à l'interface créée précédemment

# Création et configuration du texte explicatif
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20) # Position du texte dans la fenêtre
$label.Size = New-Object System.Drawing.Size(270,425) # Taille du texte explicatif
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

Important notes
This calendar is read-only (you cannot edit events unless you own the calendar).
Updates from the external calendar may take some time to sync automatically.' # Contenu du texte

$stepsForm.Controls.Add($label) # Ajout de l'élément à l'interface créée précédemment

$stepsForm.Topmost = $true # Force la fenêtre à être au premier plan

$stepsForm.ShowDialog() | Out-Null # Affichage de l'interface (Out-Null pour ne pas avoir la réponse 'cancel' dans la console fermeture)
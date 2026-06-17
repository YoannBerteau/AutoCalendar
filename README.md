# Plan

- Pitch
- Solution
    - Conception
    - Implementation
- Demo / Perfs (gain de temps, ressources -> 50 étudiants sur ade grosse consommation)
- Avantages / Inconvénients -> axes d'amélioration
- Ce que vous avez appris

## Guide d'utilisation

### Get Week ADE

Premièrement il faut installer les modules nécessaires pour Selenium. Pour cela, ouvrez PowerShell en tant qu'administrateur et exécutez la commande suivante :

```powershell
Install-Module -Name Selenium -Scope CurrentUser
```

Une fois le module installé, vous pouvez exécuter le script `get_week_ade.ps1` pour récupérer les informations de votre emploi du temps depuis ADE. Assurez-vous d'avoir le fichier `.env` avec l'URL de votre emploi du temps dans le même répertoire que le script, et exécutez le script `get_env.ps1` pour charger les variables d'environnement.

```env
URL=https://votre_url_ade
```

### Parse ADE Result

Cette étape consiste à analyser le fichier HTML récupéré par le script précédent. Exécutez le script `parse_ade_result.ps1` pour extraire les informations pertinentes et les sauvegarder dans un fichier texte.



# Utils

https://calendar.google.com/calendar/u/0/r/settings/addbyurl?pli=1  
https://www.neutrinoapi.com/api/email-validate/
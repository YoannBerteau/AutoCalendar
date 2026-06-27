# Plan

- Pitch
- Solution
    - Conception
    - Implementation
- Demo / Perfs (gain de temps, ressources -> 50 étudiants sur ade grosse consommation)
- Avantages / Inconvénients -> axes d'amélioration
- Ce que vous avez appris
- Conclusion

## Guide d'utilisation

### Guide de reproduction : Configuration Google

Pour que le script PowerShell puisse interagir avec l'agenda, voici les étapes exactes a suivre côté Google :

1. **Créer le compte "Maître" :** Un compte Google personnel classique qui sert de planning de redistribution.
2. **Créer le projet Cloud :** Sur Google Cloud Console et créer un nouveau projet nommé **"AutoPlanner"**.
3. **Activer l'API Google Calendar :** Dans la bibliothèque d'API, chercher et activer *Google Calendar API*.
   * *Note sur les quotas gratuits : La limite est très large (10 000 requêtes / minute pour le projet, et 600 requêtes / minute par utilisateur).*
4. **Créer le "Robot" (Compte de service) :** Dans *Identifiants*, créer un compte de service. Google a généré une adresse e-mail dédiée.
5. **Générer la clé P12 :** Dans l'onglet "Clés" de ce compte de service, générer et télécharger une clé au format **P12** (c'est elle que le script PowerShell utilise pour s'authentifier).
6. **Autoriser le Robot sur l'agenda :** Ouvrir Google Agenda avec le compte maître. Aller dans les paramètres de partage de l'agenda, ajouter l'e-mail du compte de service et donner obligatoirement les droits : **"Apporter des modifications aux événements"**.

---

#### Comment redistribuer le planning aux utilisateurs

Une fois l'agenda rempli automatiquement par le script, voici la méthode a utiliser pour le partager aux utilisateurs finaux sans le rendre public sur internet :

#### Côté (Administrateur / Compte maître)
1. Dans les paramètres du calendrier principal.
2. Descendre jusqu'à la section **"Intégrer l'agenda"**.
3. Repèrer la sous-partie **"Adresse secrète au format iCal"**.
4. Copier ce lien et le transmettre de manière sécurisée aux utilisateurs. *(Cela permet de partager le calendrier en lecture seule de façon privée).*

#### Du côté utilisateurs
1. L'utilisateur ouvre son propre Google Agenda.
2. Dans le menu de gauche, à côté de "Autres agendas", il clique sur le bouton **"+"** (Ajouter un agenda).
3. Il choisit **"À partir de l'URL"**.
4. Il colle l'adresse secrète iCal fournie. Le planning synchronisé apparaît instantanément !

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
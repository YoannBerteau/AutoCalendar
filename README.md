# Plan

- Pitch
- Solution
    - Conception
    - Implementation
- Demo / Perfs (gain de temps, ressources -> 50 étudiants sur ade grosse consommation)
- Avantages / Inconvénients -> axes d'amélioration
- Ce que vous avez appris

## Guide d'utilisation

### Guide de reproduction : Ma configuration Google

Pour que mon script PowerShell puisse interagir avec mon agenda, voici les étapes exactes que j'ai suivies côté Google :

1. **Créer le compte "Maître" :** J'ai créé un compte Google personnel classique qui me sert de planning de redistribution.
2. **Créer le projet Cloud :** Je me suis rendu sur Google Cloud Console et j'ai créé un nouveau projet nommé **"AutoPlanner"**.
3. **Activer l'API Google Calendar :** Dans la bibliothèque d'API, j'ai cherché et activé *Google Calendar API*.
   * *Note sur les quotas gratuits : La limite est très large (10 000 requêtes / minute pour le projet, et 600 requêtes / minute par utilisateur).*
4. **Créer le "Robot" (Compte de service) :** Dans *Identifiants*, j'ai créé un compte de service. Google m'a généré une adresse e-mail dédiée.
5. **Générer la clé P12 :** Dans l'onglet "Clés" de ce compte de service, j'ai généré et téléchargé une clé au format **P12** (c'est elle que mon script PowerShell utilise pour s'authentifier).
6. **Autoriser le Robot sur l'agenda :** J'ai ouvert Google Agenda avec mon compte maître. Je suis allé dans les paramètres de partage de l'agenda, j'ai ajouté l'e-mail de mon compte de service et je lui ai donné obligatoirement les droits : **"Apporter des modifications aux événements"**.

---

#### Comment je redistribue le planning aux utilisateurs

Une fois mon agenda rempli automatiquement par le script, voici la méthode que j'utilise pour le partager à mes utilisateurs finaux sans le rendre public sur internet :

#### De mon côté (Administrateur / Compte maître)
1. Je vais dans les paramètres de mon calendrier principal.
2. Je descends jusqu'à la section **"Intégrer l'agenda"**.
3. Je repère la sous-partie **"Adresse secrète au format iCal"**.
4. Je copie ce lien et je le transmets de manière sécurisée à mes utilisateurs. *(Cela me permet de partager le calendrier en lecture seule de façon privée).*

#### Du côté de mes utilisateurs
1. L'utilisateur ouvre son propre Google Agenda.
2. Dans le menu de gauche, à côté de "Autres agendas", il clique sur le bouton **"+"** (Ajouter un agenda).
3. Il choisit **"À partir de l'URL"**.
4. Il colle l'adresse secrète iCal que je lui ai fournie. Le planning synchronisé apparaît instantanément !

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
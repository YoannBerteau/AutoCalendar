$lignes = Get-Content -Path ... | Where-Object { $_ -match '\S' }
$len = $lignes.count
Add-Content -Path "..." -Value "["
for ($i = 0; $i -lt $len; $i += 3) {
    $lignes0 = $lignes[$i]
    $lignes1 = $lignes[$i + 1]
    $lignes2 = $lignes[$i + 2]

    $infosLigne0 = $lignes0 -split " - "
    if($infosLigne0[0] -match "\d"){
        $type = "eval"
        $res = $infosLigne0[0]
        $nom = $infosLigne0[1]
    }else{
        $type = $infosLigne0[0]
        $res = $infosLigne0[1]
        $nom = $infosLigne0[2]
    }

    $infosLigne1 = $lignes1 -split " "
    $heure_debut = $infosLigne1[0]
    $heure_fin = $infosLigne1[2]
    $salle = $infosLigne1[3]

    $prof = $lignes2

    $donnees =  @{Type=$type; Ressource=$res; Nom_Matiere=$nom; Heure_debut=$heure_debut; Heure_Fin=$heure_fin; Prof=$prof; Salle=$salle} | ConvertTo-Json -Compress
    if ($i+3 -lt $len){
        Add-Content -Path "..." -Value "$donnees,"
    } else {
        Add-Content -Path "..." -Value $donnees
    }
}
Add-Content -Path "..." -Value "]"
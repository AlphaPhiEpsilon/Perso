function Show-ConfigPopup {
    $popup = New-Object System.Windows.Forms.Form
    $popup.Text = "Correction IP / Clé SSH"
    $popup.Size = New-Object System.Drawing.Size(500, 220)
    $popup.StartPosition = "CenterScreen"
    $popup.BackColor = "#1e1e2e"
    $popup.FormBorderStyle = "FixedDialog"
    $popup.MaximizeBox = $false

    $lblIP = New-Object System.Windows.Forms.Label
    $lblIP.Text = "Adresse IP du VPS :"
    $lblIP.Location = New-Object System.Drawing.Point(20, 20)
    $lblIP.Size = New-Object System.Drawing.Size(150, 25)
    $lblIP.ForeColor = "#ffffff"
    $popup.Controls.Add($lblIP)

    $txtIPpop = New-Object System.Windows.Forms.TextBox
        $txtIPpop.Text = $global:VPS_IP
        $txtIPpop.Location = New-Object System.Drawing.Point(180, 20)
        $txtIPpop.Size = New-Object System.Drawing.Size(280, 25)
        $txtIPpop.ForeColor = "#888888"
        $txtIPpop.Add_GotFocus({
    if ($txtIPpop.Text -eq $global:VPS_IP) {
        $txtIPpop.Text = ""
        $txtIPpop.ForeColor = "#000000"
    }
})
        $txtIPpop.Add_LostFocus({
    if ([string]::IsNullOrWhiteSpace($txtIPpop.Text)) {
        $txtIPpop.Text = $global:VPS_IP
        $txtIPpop.ForeColor = "#888888"
    }
})

    $lblKey = New-Object System.Windows.Forms.Label
    $lblKey.Text = "Chemin clé SSH :"
    $lblKey.Location = New-Object System.Drawing.Point(20, 60)
    $lblKey.Size = New-Object System.Drawing.Size(150, 25)
    $lblKey.ForeColor = "#ffffff"
    $popup.Controls.Add($lblKey)

    $txtKeypop = New-Object System.Windows.Forms.TextBox
        $txtKeypop.Text = $global:sshKey
        $txtKeypop.Location = New-Object System.Drawing.Point(180, 60)
        $txtKeypop.Size = New-Object System.Drawing.Size(280, 25)
        $txtKeypop.ForeColor = "#888888"
        $txtKeypop.Add_GotFocus({
    if ($txtKeypop.Text -eq $global:sshKey) {
        $txtKeypop.Text = ""
        $txtKeypop.ForeColor = "#000000"
    }
})
        $txtKeypop.Add_LostFocus({
    if ([string]::IsNullOrWhiteSpace($txtKeypop.Text)) {
        $txtKeypop.Text = $global:sshKey
        $txtKeypop.ForeColor = "#888888"
    }
})

    $btnTest = New-Object System.Windows.Forms.Button
    $btnTest.Text = "Tester et sauvegarder"
    $btnTest.Location = New-Object System.Drawing.Point(150, 110)
    $btnTest.Size = New-Object System.Drawing.Size(200, 30)
    $btnTest.BackColor = "#2a2a3e"
    $btnTest.ForeColor = "#ffffff"
    $btnTest.FlatStyle = "Flat"
    $popup.Controls.Add($btnTest)

    $resultLabel = New-Object System.Windows.Forms.Label
    $resultLabel.Text = ""
    $resultLabel.Location = New-Object System.Drawing.Point(20, 155)
    $resultLabel.Size = New-Object System.Drawing.Size(450, 30)
    $resultLabel.ForeColor = "#ff8888"
    $popup.Controls.Add($resultLabel)

    $btnTest.Add_Click({
        $testIP = $txtIPpop.Text
        $testKey = $txtKeypop.Text
        $testCmd = ssh -i "$testKey" -o ConnectTimeout=5 root@$testIP "echo OK" 2>&1
        if ($testCmd -match "OK") {
            # Sauvegarde dans dashboard_config.ps1
            $configFile = Join-Path $PSScriptRoot "dashboard_config.ps1"
            $contenu = Get-Content $configFile -Raw
            $contenu = $contenu -replace "`$global:VPS_IP = `".*`"", "`$global:VPS_IP = `"$testIP`""
            $contenu = $contenu -replace "`$global:sshKey = `".*`"", "`$global:sshKey = `"$testKey`""
            $contenu | Set-Content $configFile -Encoding UTF8
            $global:VPS_IP = $testIP
            $global:sshKey = $testKey
            $resultLabel.ForeColor = "#86efac"
            $resultLabel.Text = "Succès ! Redémarrage du dashboard..."
            $popup.DialogResult = "OK"
            $popup.Close()
        } else {
            $resultLabel.Text = "Échec connexion. Vérifie IP / clé."
        }
    })

    $popup.ShowDialog()
    return $popup.DialogResult
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ==============================================
# CHARGEMENT DE LA CONFIGURATION
# ==============================================
. "$PSScriptRoot\dashboard_config.ps1"



# Test de connexion SSH avec gestion d'erreur silencieuse
$sshTest = ssh -o ConnectTimeout=5 -i $global:sshKey root@$global:VPS_IP "echo OK" 2>$null
if ($sshTest -ne "OK") {
    # La connexion a échoué : on ouvre la popup de correction
    $result = Show-ConfigPopup
    if ($result -eq "OK") {
        # Les infos ont été corrigées et sauvegardées, on relance le script
        & $PSCommandPath
        exit
    } else {
        # L'utilisateur a fermé la popup sans corriger
        [System.Windows.Forms.MessageBox]::Show("Configuration invalide. Le dashboard va fermer.", "Erreur", "OK", "Error")
        exit
    }
}
Write-DebugLog "Connexion SSH OK"

# ==============================================
# CHARGEMENT DES MODULES
# ==============================================
# Ces fichiers doivent se trouver dans le même dossier que main
. "$PSScriptRoot\dashboard_ui.ps1"        # 1. Crée les cartes
. "$PSScriptRoot\dashboard_stream.ps1"    # 2. Streaming
. "$PSScriptRoot\dashboard_zoom.ps1"      # 3. Zoom (dépend des cartes)
. "$PSScriptRoot\dashboard_actions.ps1"   # 4. Actions  # Menus Actions, boutons panel gauche
  # Configuration du Dashboard De Controle V.P.S

# ==============================================
# LANCEMENT (les variables $script:autoMode et $form sont définies dans les modules)
# ==============================================
if ($script:autoMode) { Start-GlobalStream }
$form.ShowDialog()
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ==============================================
# CONFIGURATION
# ==============================================
$VPS_IP = "$global:VPS_IP"



# Test connexion SSH
$sshTest = ssh -o ConnectTimeout=5 root@$global:VPS_IP "echo OK" 2>$null
if ($sshTest -ne "OK") {
    [System.Windows.Forms.MessageBox]::Show("Impossible de se connecter au VPS $VPS_IP`nVérifie la clé SSH.", "Erreur SSH", "OK", "Error")
    Write-DebugLog "ÉCHEC connexion SSH" "ERROR"
    exit
}


# ==============================================
# CHARGEMENT DES MODULES
# ==============================================
# Ces fichiers doivent se trouver dans le même dossier que main
. "$PSScriptRoot\dashboard_ui.ps1"        # Interface utilisateur (fenêtre, cartes, etc.)
. "$PSScriptRoot\dashboard_stream.ps1"    # Streaming, logs, LEDs
. "$PSScriptRoot\dashboard_zoom.ps1"      # Fonction Toggle-Zoom et événements
. "$PSScriptRoot\dashboard_actions.ps1"   # Menus Actions, boutons panel gauche
. "$PSScriptRoot\dashboard_config.ps1"    # Configuration du Dashboard De Controle V.P.S

# ==============================================
# LANCEMENT (les variables $script:autoMode et $form sont définies dans les modules)
# ==============================================
if ($script:autoMode) { Start-GlobalStream }
$form.ShowDialog()
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ==============================================
# CONFIGURATION
# ==============================================
$VPS_IP = "141.11.103.64"
$DEBUG_LOG = "C:\Users\Teri\Desktop\log\dashboard_debug.log"

$logDir = Split-Path $DEBUG_LOG -Parent
if (!(Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force }

function Write-DebugLog {
    param($Message, $Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$Level] $Message"
    Add-Content -Path $DEBUG_LOG -Value $logEntry
}
Write-DebugLog "=== DASHBOARD DÉMARRÉ ==="

# Test connexion SSH
$sshTest = ssh -o ConnectTimeout=5 root@$VPS_IP "echo OK" 2>$null
if ($sshTest -ne "OK") {
    [System.Windows.Forms.MessageBox]::Show("Impossible de se connecter au VPS $VPS_IP`nVérifie la clé SSH.", "Erreur SSH", "OK", "Error")
    Write-DebugLog "ÉCHEC connexion SSH" "ERROR"
    exit
}
Write-DebugLog "Connexion SSH OK"

# ==============================================
# CHARGEMENT DES MODULES
# ==============================================
# Ces fichiers doivent se trouver dans le même dossier que main
. "$PSScriptRoot\dashboard_ui.ps1"        # Interface utilisateur (fenêtre, cartes, etc.)
. "$PSScriptRoot\dashboard_stream.ps1"    # Streaming, logs, LEDs
. "$PSScriptRoot\dashboard_zoom.ps1"      # Fonction Toggle-Zoom et événements
. "$PSScriptRoot\dashboard_actions.ps1"   # Menus Actions, boutons panel gauche

# ==============================================
# LANCEMENT (les variables $script:autoMode et $form sont définies dans les modules)
# ==============================================
if ($script:autoMode) { Start-GlobalStream }
$form.ShowDialog()
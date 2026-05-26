#Projet en cours

[System.Windows.Forms.Application]::EnableVisualStyles()

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ==============================================
# DÉMARRAGE DE L'ENREGISTREMENT DE TOUTE LA SESSION
# ==============================================
$TranscriptLog = "C:\Users\Teri\Desktop\log\powershell_complet.log"
$logDir = Split-Path $TranscriptLog -Parent
if (!(Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force }
Start-Transcript -Path $TranscriptLog -Append

# ==============================================
# CONFIGURATION
# ==============================================
$VPS_IP = "141.11.103.64"
$DEBUG_LOG = "C:\Users\Teri\Desktop\log\dashboard_debug.log"

# Créer le dossier de log s'il n'existe pas
$logDir = Split-Path $DEBUG_LOG -Parent
if (!(Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force }

# Fonction d'écriture de log
function Write-DebugLog {
    param($Message, $Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$Level] $Message"
    Add-Content -Path $DEBUG_LOG -Value $logEntry
    Write-Host $logEntry
}

Write-DebugLog "=== DASHBOARD DÉMARRÉ ==="

# ==============================================
# CAPTURE DES ERREURS WINDOWS POWERSHELL
# ==============================================

# Fichier de log des erreurs PowerShell
$POWERSHELL_ERROR_LOG = "C:\Users\Teri\Desktop\log\powershell_errors.log"

function Write-PowerShellError {
    param($Exception, $Source = "UNKNOWN")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $errorMessage = "ERROR: $timestamp [$Source] $($Exception.Message)"
    if ($Exception.InvocationInfo) {
        $errorMessage += " | Ligne: $($Exception.InvocationInfo.ScriptLineNumber) | Commande: $($Exception.InvocationInfo.Line)"
    }
    # Écrire uniquement dans le log existant
    Add-Content -Path $POWERSHELL_ERROR_LOG -Value $errorMessage
    # Plus de Write-Host = plus de popups
}


# Créer le dossier s'il n'existe pas
$logDir = Split-Path $POWERSHELL_ERROR_LOG -Parent
if (!(Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force }


# Capturer TOUTES les erreurs (celles qui apparaissent en popup)
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"

# Rediriger les erreurs non gérées
$null = [System.AppDomain]::CurrentDomain.Add_UnhandledException({
    param($sender, $e)
    Write-Error -Exception $e.ExceptionObject -Source "UNHANDLED_EXCEPTION"
})

# Capturer les erreurs de type ThrowTerminatingError
trap {
    Write-PowerShellError -Exception $_ -Source "TRAP"
    continue
}

# Démarrer un job en arrière-plan pour surveiller les erreurs de la console
$errorMonitorScript = {
    $lastErrorCount = 0
    while ($true) {
        $currentErrors = $global:Error
        if ($currentErrors.Count -gt $lastErrorCount) {
            $newErrors = $currentErrors | Select-Object -Skip $lastErrorCount
            foreach ($err in $newErrors) {
                $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                $errorLine = "CONSOLE_ERROR: $timestamp $($err.ToString())"
                Add-Content -Path "C:\Users\Teri\Desktop\log\powershell_errors.log" -Value $errorLine
            }
            $lastErrorCount = $currentErrors.Count
        }
        Start-Sleep -Milliseconds 500
    }
}

# Démarrer le moniteur d'erreurs en arrière-plan
Start-Job -ScriptBlock $errorMonitorScript | Out-Null

Write-Host "✅ Capture des erreurs PowerShell activée" -ForegroundColor Green
Write-Host "📁 Log des erreurs: $POWERSHELL_ERROR_LOG" -ForegroundColor Cyan

# ==============================================
# FENÊTRE PRINCIPALE
# ==============================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "MeetGay VPS Dashboard - $VPS_IP"
$form.Size = New-Object System.Drawing.Size(1400, 900)
$form.StartPosition = "CenterScreen"
$form.BackColor = "#1e1e2e"

# ==============================================
# PANEL GAUCHE (boutons)
# ==============================================
$panelLeft = New-Object System.Windows.Forms.Panel
$panelLeft.Size = New-Object System.Drawing.Size(280, 850)
$panelLeft.Location = New-Object System.Drawing.Point(10, 40)
$panelLeft.BackColor = "#2d2d2d"
$form.Controls.Add($panelLeft)

$yPos = 10

$lblMonitoring = New-Object System.Windows.Forms.Label
$lblMonitoring.Text = "📊 MONITORING"
$lblMonitoring.Size = New-Object System.Drawing.Size(260, 30)
$lblMonitoring.Location = New-Object System.Drawing.Point(10, $yPos)
$lblMonitoring.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$lblMonitoring.ForeColor = "#88c0d0"
$panelLeft.Controls.Add($lblMonitoring)
$yPos += 35

$btnMonitoring = New-Object System.Windows.Forms.Button
$btnMonitoring.Text = "Monitoring complet"
$btnMonitoring.Size = New-Object System.Drawing.Size(260, 35)
$btnMonitoring.Location = New-Object System.Drawing.Point(10, $yPos)
$btnMonitoring.BackColor = "#000000"
$btnMonitoring.ForeColor = "#ffffff"
$btnMonitoring.FlatStyle = "Flat"
$btnMonitoring.TextAlign = "MiddleLeft"
$panelLeft.Controls.Add($btnMonitoring)
$yPos += 42

$btnStatus = New-Object System.Windows.Forms.Button
$btnStatus.Text = "Status rapide"
$btnStatus.Size = New-Object System.Drawing.Size(260, 35)
$btnStatus.Location = New-Object System.Drawing.Point(10, $yPos)
$btnStatus.BackColor = "#000000"
$btnStatus.ForeColor = "#ffffff"
$btnStatus.FlatStyle = "Flat"
$btnStatus.TextAlign = "MiddleLeft"
$panelLeft.Controls.Add($btnStatus)
$yPos += 52

$lblLogs = New-Object System.Windows.Forms.Label
$lblLogs.Text = "📜 LOGS"
$lblLogs.Size = New-Object System.Drawing.Size(260, 30)
$lblLogs.Location = New-Object System.Drawing.Point(10, $yPos)
$lblLogs.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$lblLogs.ForeColor = "#88c0d0"
$panelLeft.Controls.Add($lblLogs)
$yPos += 35

$btnLogsSimple = New-Object System.Windows.Forms.Button
$btnLogsSimple.Text = "Logs (simple)"
$btnLogsSimple.Size = New-Object System.Drawing.Size(260, 35)
$btnLogsSimple.Location = New-Object System.Drawing.Point(10, $yPos)
$btnLogsSimple.BackColor = "#000000"
$btnLogsSimple.ForeColor = "#ffffff"
$btnLogsSimple.FlatStyle = "Flat"
$btnLogsSimple.TextAlign = "MiddleLeft"
$panelLeft.Controls.Add($btnLogsSimple)
$yPos += 42

$btnLogsRealtime = New-Object System.Windows.Forms.Button
$btnLogsRealtime.Text = "📡 Logs (temps réel)"
$btnLogsRealtime.Size = New-Object System.Drawing.Size(260, 35)
$btnLogsRealtime.Location = New-Object System.Drawing.Point(10, $yPos)
$btnLogsRealtime.BackColor = "#1a3a1a"
$btnLogsRealtime.ForeColor = "#ffffff"
$btnLogsRealtime.FlatStyle = "Flat"
$btnLogsRealtime.TextAlign = "MiddleLeft"
$panelLeft.Controls.Add($btnLogsRealtime)
$yPos += 52

$lblControl = New-Object System.Windows.Forms.Label
$lblControl.Text = "🔧 CONTROLE VPS"
$lblControl.Size = New-Object System.Drawing.Size(260, 30)
$lblControl.Location = New-Object System.Drawing.Point(10, $yPos)
$lblControl.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$lblControl.ForeColor = "#88c0d0"
$panelLeft.Controls.Add($lblControl)
$yPos += 35

$btnReboot = New-Object System.Windows.Forms.Button
$btnReboot.Text = "🔄 Reboot VPS (doux)"
$btnReboot.Size = New-Object System.Drawing.Size(260, 35)
$btnReboot.Location = New-Object System.Drawing.Point(10, $yPos)
$btnReboot.BackColor = "#3a2a1a"
$btnReboot.ForeColor = "#ffffff"
$btnReboot.FlatStyle = "Flat"
$btnReboot.TextAlign = "MiddleLeft"
$panelLeft.Controls.Add($btnReboot)
$yPos += 42

$btnForceReboot = New-Object System.Windows.Forms.Button
$btnForceReboot.Text = "⚠️ Force reboot"
$btnForceReboot.Size = New-Object System.Drawing.Size(260, 35)
$btnForceReboot.Location = New-Object System.Drawing.Point(10, $yPos)
$btnForceReboot.BackColor = "#3a1a1a"
$btnForceReboot.ForeColor = "#ffffff"
$btnForceReboot.FlatStyle = "Flat"
$btnForceReboot.TextAlign = "MiddleLeft"
$panelLeft.Controls.Add($btnForceReboot)
$yPos += 52

$lblSecurite = New-Object System.Windows.Forms.Label
$lblSecurite.Text = "🔒 SECURITE"
$lblSecurite.Size = New-Object System.Drawing.Size(260, 30)
$lblSecurite.Location = New-Object System.Drawing.Point(10, $yPos)
$lblSecurite.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$lblSecurite.ForeColor = "#88c0d0"
$panelLeft.Controls.Add($lblSecurite)
$yPos += 35

$btnSecurite = New-Object System.Windows.Forms.Button
$btnSecurite.Text = "Securite (Fail2ban)"
$btnSecurite.Size = New-Object System.Drawing.Size(260, 35)
$btnSecurite.Location = New-Object System.Drawing.Point(10, $yPos)
$btnSecurite.BackColor = "#000000"
$btnSecurite.ForeColor = "#ffffff"
$btnSecurite.FlatStyle = "Flat"
$btnSecurite.TextAlign = "MiddleLeft"
$panelLeft.Controls.Add($btnSecurite)

# BOUTON KILL SSH D'URGENCE
$yPos += 52
$btnKillSSH = New-Object System.Windows.Forms.Button
$btnKillSSH.Text = "⚠️ KILL SSH (urgence)"
$btnKillSSH.Size = New-Object System.Drawing.Size(260, 35)
$btnKillSSH.Location = New-Object System.Drawing.Point(10, $yPos)
$btnKillSSH.BackColor = "#5a1a1a"
$btnKillSSH.ForeColor = "#ff8888"
$btnKillSSH.FlatStyle = "Flat"
$btnKillSSH.TextAlign = "MiddleLeft"
$panelLeft.Controls.Add($btnKillSSH)

# BOUTON SWITCH AUTO/MANUEL
$yPos += 52
$btnAutoMode = New-Object System.Windows.Forms.Button
$btnAutoMode.Text = "🔄 MODE: AUTO (logs démarrent)"
$btnAutoMode.Size = New-Object System.Drawing.Size(260, 35)
$btnAutoMode.Location = New-Object System.Drawing.Point(10, $yPos)
$btnAutoMode.BackColor = "#1a3a1a"
$btnAutoMode.ForeColor = "#86efac"
$btnAutoMode.FlatStyle = "Flat"
$btnAutoMode.TextAlign = "MiddleLeft"
$panelLeft.Controls.Add($btnAutoMode)

# ==============================================
# PANEL STATUTS (LED)
# ==============================================
$panelStatus = New-Object System.Windows.Forms.Panel
$panelStatus.Size = New-Object System.Drawing.Size(1080, 100)
$panelStatus.Location = New-Object System.Drawing.Point(300, 40)
$panelStatus.BackColor = "#2d2d2d"
$form.Controls.Add($panelStatus)

$services = @("📦 meetgay", "📦 control", "🌐 nginx", "🐘 postgresql", "🐘 php", "🚀 node.js")
$ledLabels = @()
$uptimeLabels = @()

for ($i=0; $i -lt $services.Length; $i++) {
    $x = 10 + ($i * 140)
    $card = New-Object System.Windows.Forms.GroupBox
    $card.Text = $services[$i]
    $card.Size = New-Object System.Drawing.Size(130, 85)
    $card.Location = New-Object System.Drawing.Point($x, 10)
    $card.ForeColor = "#ffffff"
    $card.BackColor = "#1a1a2e"
    $panelStatus.Controls.Add($card)
    
    $led = New-Object System.Windows.Forms.Label
    $led.Text = "● ?"
    $led.ForeColor = "#888888"
    $led.Size = New-Object System.Drawing.Size(110, 25)
    $led.Location = New-Object System.Drawing.Point(10, 20)
    $led.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
    $card.Controls.Add($led)
    $ledLabels += $led
    
    $uptime = New-Object System.Windows.Forms.Label
    $uptime.Text = "?"
    $uptime.Size = New-Object System.Drawing.Size(110, 20)
    $uptime.Location = New-Object System.Drawing.Point(10, 50)
    $uptime.Font = New-Object System.Drawing.Font("Segoe UI", 7)
    $uptime.ForeColor = "#aaaaaa"
    $card.Controls.Add($uptime)
    $uptimeLabels += $uptime
}

# ==============================================
# TABCONTROL
# ==============================================
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(1080, 700)
$tabControl.Location = New-Object System.Drawing.Point(300, 150)
$form.Controls.Add($tabControl)

# ==============================================
# ONGLET SYSTEME
# ==============================================
$tabSysteme = New-Object System.Windows.Forms.TabPage
$tabSysteme.Text = "📊 SYSTEME"
$tabSysteme.BackColor = "#1e1e2e"
$tabControl.Controls.Add($tabSysteme)

$sysGroup = New-Object System.Windows.Forms.GroupBox
$sysGroup.Text = "📋 LOGS SYSTÈME (journalctl)"
$sysGroup.Size = New-Object System.Drawing.Size(1060, 420)
$sysGroup.Location = New-Object System.Drawing.Point(10, 10)
$sysGroup.ForeColor = "#ffffff"
$sysGroup.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$sysGroup.BackColor = "#0f172a"
$tabSysteme.Controls.Add($sysGroup)

$sysLogBox = New-Object System.Windows.Forms.RichTextBox
$sysLogBox.Size = New-Object System.Drawing.Size(1040, 380)
$sysLogBox.Location = New-Object System.Drawing.Point(10, 25)
$sysLogBox.BackColor = "#0a0f1a"
$sysLogBox.ForeColor = "#86efac"
$sysLogBox.Font = New-Object System.Drawing.Font("Consolas", 8)
$sysLogBox.ReadOnly = $true
$sysLogBox.Text = "[En attente des logs système...]"
$sysGroup.Controls.Add($sysLogBox)

$cmdGroup = New-Object System.Windows.Forms.GroupBox
$cmdGroup.Text = "📟 COMMANDES (résultats)"
$cmdGroup.Size = New-Object System.Drawing.Size(1060, 200)
$cmdGroup.Location = New-Object System.Drawing.Point(10, 440)
$cmdGroup.ForeColor = "#ffffff"
$cmdGroup.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$cmdGroup.BackColor = "#0f172a"
$tabSysteme.Controls.Add($cmdGroup)

$cmdBox = New-Object System.Windows.Forms.RichTextBox
$cmdBox.Size = New-Object System.Drawing.Size(1040, 160)
$cmdBox.Location = New-Object System.Drawing.Point(10, 25)
$cmdBox.BackColor = "#0a0f1a"
$cmdBox.ForeColor = "#ffaa00"
$cmdBox.Font = New-Object System.Drawing.Font("Consolas", 8)
$cmdBox.ReadOnly = $true
$cmdBox.Text = "[En attente des commandes...]"
$cmdGroup.Controls.Add($cmdBox)

# ==============================================
# ONGLET SERVICES (6 cartes)
# ==============================================
$tabServices = New-Object System.Windows.Forms.TabPage
$tabServices.Text = "🖥️ SERVICES"
$tabServices.BackColor = "#1e1e2e"
$tabControl.Controls.Add($tabServices)

$gridLogs = New-Object System.Windows.Forms.Panel
$gridLogs.Size = New-Object System.Drawing.Size(1060, 660)
$gridLogs.Location = New-Object System.Drawing.Point(10, 10)
$gridLogs.BackColor = "transparent"
$tabServices.Controls.Add($gridLogs)

# Création des 6 cartes
$logBoxes = @()
$btnRefreshes = @()
$btnClears = @()
$btnActionses = @()

for ($i = 0; $i -lt 6; $i++) {
    $x = if ($i -lt 3) { $i * 350 } else { ($i - 3) * 350 }
    $y = if ($i -lt 3) { 0 } else { 310 }
    
    $card = New-Object System.Windows.Forms.GroupBox
    $card.Text = $services[$i]
    $card.Size = New-Object System.Drawing.Size(340, 300)
    $card.Location = New-Object System.Drawing.Point($x, $y)
    $card.ForeColor = "#ffffff"
    $card.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $card.BackColor = "#0f172a"
    $gridLogs.Controls.Add($card)
    
    $logBox = New-Object System.Windows.Forms.RichTextBox
    $logBox.Size = New-Object System.Drawing.Size(325, 220)
    $logBox.Location = New-Object System.Drawing.Point(5, 40)
    $logBox.BackColor = "#0a0f1a"
    $logBox.ForeColor = "#86efac"
    $logBox.Font = New-Object System.Drawing.Font("Consolas", 7)
    $logBox.ReadOnly = $true
    $logBox.Text = "[En attente...]"
    $card.Controls.Add($logBox)
    $logBoxes += $logBox
    
    $btnActions = New-Object System.Windows.Forms.Button
    $btnActions.Text = "⚙️ Actions"
    $btnActions.Size = New-Object System.Drawing.Size(75, 25)
    $btnActions.Location = New-Object System.Drawing.Point(10, 8)
    $btnActions.BackColor = "#2a2a3e"
    $btnActions.ForeColor = "#ffffff"
    $btnActions.FlatStyle = "Flat"
    $card.Controls.Add($btnActions)
    $btnActionses += $btnActions
    
    $btnRefresh = New-Object System.Windows.Forms.Button
    $btnRefresh.Text = "⟳"
    $btnRefresh.Size = New-Object System.Drawing.Size(35, 25)
    $btnRefresh.Location = New-Object System.Drawing.Point(250, 8)
    $btnRefresh.BackColor = "#1a3a1a"
    $btnRefresh.ForeColor = "#ffffff"
    $btnRefresh.FlatStyle = "Flat"
    $card.Controls.Add($btnRefresh)
    $btnRefreshes += $btnRefresh
    
    $btnClear = New-Object System.Windows.Forms.Button
    $btnClear.Text = "🗑"
    $btnClear.Size = New-Object System.Drawing.Size(35, 25)
    $btnClear.Location = New-Object System.Drawing.Point(290, 8)
    $btnClear.BackColor = "#3a1a1a"
    $btnClear.ForeColor = "#ffffff"
    $btnClear.FlatStyle = "Flat"
    $card.Controls.Add($btnClear)
    $btnClears += $btnClear
}

# ==============================================
# VARIABLES DE STREAMING
# ==============================================
$script:streamJob = $null
$script:streamActive = $false
$script:streamTimer = $null
$script:autoMode = $true
$script:services = @("MEETGAY", "CONTROL", "NGINX_ACCESS", "POSTGRESQL", "PHP", "NODEJS")
$script:serviceColors = @{
    "MEETGAY" = "#86efac"
    "CONTROL" = "#86efac"
    "NGINX_ACCESS" = "#86efac"
    "NGINX_ERROR" = "#f87171"
    "POSTGRESQL" = "#86efac"
    "PHP" = "#86efac"
    "NODEJS" = "#86efac"
}

# Fonction pour ajouter une ligne colorée dans une logBox
function Add-ColoredLine {
    param($box, $line)
    $box.SuspendLayout()
    $box.SelectionStart = $box.TextLength
    $box.SelectionLength = 0
    
    # Déterminer la couleur selon le préfixe et le contenu
    $color = "#86efac" # vert par défaut
    if ($line -match "\[(.*?)\]") {
        $prefix = $matches[1]
        if ($script:serviceColors.ContainsKey($prefix)) {
            $color = $script:serviceColors[$prefix]
        }
    }
    if ($line -match "(?i)(error|fail|fatal|exception|refused)") {
        $color = "#f87171" # rouge
    }
    elseif ($line -match "(?i)(warn|warning)") {
        $color = "#fbbf24" # jaune
    }
    
    $box.SelectionColor = $color
    $box.AppendText($line + "`n")
    $box.SelectionStart = $box.Text.Length
    $box.ScrollToCaret()
    $box.ResumeLayout()
}

# Fonction pour démarrer le stream unique
function Start-GlobalStream {
    if ($script:streamActive) {
        Write-DebugLog "Stream déjà actif, ignore" "WARN"
        return
    }
    
    Write-DebugLog "Démarrage du stream unique vers $VPS_IP"
    
    for ($i = 0; $i -lt 6; $i++) {
        $logBoxes[$i].Clear()
        $logBoxes[$i].Text = "[Connexion à $VPS_IP...]`n"
    }
    $sysLogBox.Clear()
    $sysLogBox.Text = "[Connexion...]`n"
    
    $script:streamActive = $true
    $script:streamJob = Start-Job -ScriptBlock {
        param($ip)
        ssh -q -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no root@$ip "/root/stream-logs.sh" 2>&1
    } -ArgumentList $VPS_IP
    
    $script:streamTimer = New-Object System.Windows.Forms.Timer
    $script:streamTimer.Interval = 300
    $script:streamTimer.Add_Tick({
        if ($script:streamJob -ne $null -and $script:streamActive) {
            if ($script:streamJob.HasMoreData) {
                $lines = Receive-Job -Job $script:streamJob
                if ($lines) {
                    if ($lines -is [array]) {
                        foreach ($line in $lines) {
                            Process-LogLine $line
                        }
                    } else {
                        Process-LogLine $lines
                    }
                }
            }
            if ($script:streamJob.State -ne 'Running') {
                $remaining = Receive-Job -Job $script:streamJob
                if ($remaining) { Process-LogLine $remaining }
                Remove-Job $script:streamJob -Force
                $script:streamJob = $null
                $script:streamActive = $false
                $script:streamTimer.Stop()
                Write-DebugLog "Stream arrêté" "WARN"
                for ($i = 0; $i -lt 6; $i++) {
                    Add-ColoredLine $logBoxes[$i] "[STREAM] Connexion perdue, cliquez sur ⟳ pour reconnecter"
                }
            }
        }
    })
    $script:streamTimer.Start()
    Write-DebugLog "Stream démarré avec succès"
}

function Process-LogLine {
    param($line)
    if ([string]::IsNullOrWhiteSpace($line)) { return }
    
    # Système logs
    Add-ColoredLine $sysLogBox $line
    
    # Distribution vers les cartes selon préfixe
    if ($line -match "^\[MEETGAY\]") {
        Add-ColoredLine $logBoxes[0] $line
    }
    elseif ($line -match "^\[CONTROL\]") {
        Add-ColoredLine $logBoxes[1] $line
    }
    elseif ($line -match "^\[NGINX_(ACCESS|ERROR)\]") {
        Add-ColoredLine $logBoxes[2] $line
    }
    elseif ($line -match "^\[POSTGRESQL\]") {
        Add-ColoredLine $logBoxes[3] $line
    }
    elseif ($line -match "^\[PHP\]") {
        Add-ColoredLine $logBoxes[4] $line
    }
    elseif ($line -match "^\[NODEJS\]") {
        Add-ColoredLine $logBoxes[5] $line
    }
}

function Stop-GlobalStream {
    if (-not $script:streamActive) { return }
    Write-DebugLog "Arrêt du stream"
    $script:streamActive = $false
    if ($script:streamTimer) { $script:streamTimer.Stop() }
    if ($script:streamJob) { 
        Stop-Job $script:streamJob
        Receive-Job $script:streamJob
        Remove-Job $script:streamJob
        $script:streamJob = $null
    }
    Write-DebugLog "Stream arrêté proprement"
}

function Kill-AllSSH {
    Write-DebugLog "KILL SSH d'urgence exécuté" "WARN"
    Stop-GlobalStream
    Get-Process -Name "ssh" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Milliseconds 500
    Write-DebugLog "Tous les processus SSH ont été tués" "INFO"
}

# Bouton KILL SSH
$btnKillSSH.Add_Click({
    Kill-AllSSH
    $cmdBox.AppendText("[KILL SSH] Toutes les connexions SSH ont été fermées`n")
})

# Bouton AUTO/MANUEL
function UpdateAutoModeButton {
    if ($script:autoMode) {
        $btnAutoMode.Text = "🔄 MODE: AUTO (logs démarrent)"
        $btnAutoMode.BackColor = "#1a3a1a"
        $btnAutoMode.ForeColor = "#86efac"
    } else {
        $btnAutoMode.Text = "⏹️ MODE: MANUEL (logs arrêtés)"
        $btnAutoMode.BackColor = "#3a1a1a"
        $btnAutoMode.ForeColor = "#f87171"
    }
}

$btnAutoMode.Add_Click({
    $script:autoMode = -not $script:autoMode
    UpdateAutoModeButton
    if ($script:autoMode) {
        Start-GlobalStream
        $cmdBox.AppendText("[MODE] Passage en AUTO - démarrage des logs`n")
    } else {
        Stop-GlobalStream
        $cmdBox.AppendText("[MODE] Passage en MANUEL - logs arrêtés`n")
    }
})

# Boutons Refresh pour chaque carte
$btnRefreshes[$index].Add_Click({
    # DEBUG FORCE - HELLO WORLD
    $debugFile = "C:\Users\Teri\Desktop\log\dashboard_debug.log"
    [System.IO.File]::WriteAllText($debugFile, "HELLO WORLD - " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + " - Carte $index`r`n")
    
    $logBoxes[$index].Clear()
    $logBoxes[$index].AppendText("[REFRESH] Affichage vidé`n")
})

# Boutons Clear pour chaque carte
for ($i = 0; $i -lt 6; $i++) {
    $index = $i
    $btnClears[$index].Add_Click({
        $logBoxes[$index].Clear()
        $logBoxes[$index].AppendText("[CLEAR] Logs effacés localement`n")
    })
}

# Menus Actions pour chaque carte
$actionCommands = @(
    @{service="meetgay"; pm2=true; actions="gracefulReload","stop","start","restart","delete","status","monit","flush","save"},
    @{service="control"; pm2=true; actions="gracefulReload","stop","start","restart","delete","status","monit","flush","save"},
    @{service="nginx"; pm2=false; actions="reload","stop","start","restart","status"},
    @{service="postgresql"; pm2=false; actions="reload","stop","start","restart","status"},
    @{service="php8.3-fpm"; pm2=false; actions="reload","stop","start","restart","status"},
    @{service="nodejs"; pm2=true; actions="gracefulReload","stop","start","restart","delete","status","monit","flush","save"}
)

for ($i = 0; $i -lt 6; $i++) {
    $index = $i
    $menu = New-Object System.Windows.Forms.ContextMenuStrip
    $serviceInfo = $actionCommands[$index]
    
    foreach ($action in $serviceInfo.actions) {
        $item = New-Object System.Windows.Forms.ToolStripMenuItem
        $item.Text = $action
        $item.Add_Click({
            $cmdBox.AppendText("[ACTION] $($serviceInfo.service) - $($this.Text)`n")
            Write-DebugLog "Action $($this.Text) sur $($serviceInfo.service)"
            if ($serviceInfo.pm2) {
                Start-Job -ScriptBlock {
                    param($ip, $service, $action)
                    ssh -q -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no root@$ip "pm2 $action $service" 2>&1 | Out-Null
                } -ArgumentList $VPS_IP, $serviceInfo.service, $action | Out-Null
            } else {
                Start-Job -ScriptBlock {
                    param($ip, $service, $action)
                    ssh -q -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no root@$ip "systemctl $action $service" 2>&1 | Out-Null
                } -ArgumentList $VPS_IP, $serviceInfo.service, $action | Out-Null
            }
        })
        $menu.Items.Add($item)
    }
    $btnActionses[$index].ContextMenuStrip = $menu
}

# Rafraîchissement LED toutes les 10 secondes
function Update-LEDs {
    Write-DebugLog "Rafraîchissement LED"
    Start-Job -ScriptBlock {
        param($ip)
        $result = ssh root@$ip "pm2 list --no-color 2>/dev/null | grep -E 'meetgay|control|node' ; systemctl is-active nginx postgresql php8.3-fpm 2>/dev/null"
        return $result
    } -ArgumentList $VPS_IP | Out-Null
}

$ledTimer = New-Object System.Windows.Forms.Timer
$ledTimer.Interval = 10000
$ledTimer.Add_Tick({
    $job = Start-Job -ScriptBlock {
        param($ip)
        $status = @{}
        $pm2 = ssh root@$ip "pm2 list --no-color 2>/dev/null"
        $status.meetgay = if ($pm2 -match "meetgay.*online") { "online" } else { "offline" }
        $status.control = if ($pm2 -match "control.*online") { "online" } else { "offline" }
        $status.nodejs = if ($pm2 -match "node.*online") { "online" } else { "offline" }
        $status.nginx = (ssh root@$ip "systemctl is-active nginx 2>/dev/null").Trim()
        $status.postgresql = (ssh root@$ip "systemctl is-active postgresql 2>/dev/null").Trim()
        $status.php = (ssh root@$ip "systemctl is-active php8.3-fpm 2>/dev/null").Trim()
        return $status
    } -ArgumentList $VPS_IP
    
    $result = Receive-Job $job -ErrorAction SilentlyContinue
    if ($result) {
        $ledLabels[0].Text = if ($result.meetgay -eq "online") { "● EN LIGNE" } else { "○ HORS LIGNE" }
        $ledLabels[0].ForeColor = if ($result.meetgay -eq "online") { "#2ecc71" } else { "#e74c3c" }
        $ledLabels[1].Text = if ($result.control -eq "online") { "● EN LIGNE" } else { "○ HORS LIGNE" }
        $ledLabels[1].ForeColor = if ($result.control -eq "online") { "#2ecc71" } else { "#e74c3c" }
        $ledLabels[2].Text = if ($result.nginx -eq "active") { "● EN LIGNE" } else { "○ HORS LIGNE" }
        $ledLabels[2].ForeColor = if ($result.nginx -eq "active") { "#2ecc71" } else { "#e74c3c" }
        $ledLabels[3].Text = if ($result.postgresql -eq "active") { "● EN LIGNE" } else { "○ HORS LIGNE" }
        $ledLabels[3].ForeColor = if ($result.postgresql -eq "active") { "#2ecc71" } else { "#e74c3c" }
        $ledLabels[4].Text = if ($result.php -eq "active") { "● EN LIGNE" } else { "○ HORS LIGNE" }
        $ledLabels[4].ForeColor = if ($result.php -eq "active") { "#2ecc71" } else { "#e74c3c" }
        $ledLabels[5].Text = if ($result.nodejs -eq "online") { "● EN LIGNE" } else { "○ HORS LIGNE" }
        $ledLabels[5].ForeColor = if ($result.nodejs -eq "online") { "#2ecc71" } else { "#e74c3c" }
    }
})
$ledTimer.Start()

# ==============================================
# TITRE ET HORLOGE
# ==============================================
$title = New-Object System.Windows.Forms.Label
$title.Text = "MEETGAY VPS DASHBOARD"
$title.Size = New-Object System.Drawing.Size(400, 30)
$title.Location = New-Object System.Drawing.Point(10, 5)
$title.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = "#ffffff"
$form.Controls.Add($title)

$clock = New-Object System.Windows.Forms.Label
$clock.Size = New-Object System.Drawing.Size(200, 30)
$clock.Location = New-Object System.Drawing.Point(1180, 5)
$clock.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$clock.ForeColor = "#86efac"
$clock.TextAlign = "MiddleRight"
$form.Controls.Add($clock)

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000
$timer.Add_Tick({ $clock.Text = Get-Date -Format "HH:mm:ss" })
$timer.Start()

# Fermeture propre
$form.Add_FormClosing({
    Write-DebugLog "Fermeture du dashboard"
    Stop-GlobalStream
    $timer.Stop()
    $ledTimer.Stop()
    Stop-Transcript
    [System.Environment]::Exit(0)
})



# Démarrage AUTO
UpdateAutoModeButton
if ($script:autoMode) { Start-GlobalStream }

# Bloquer les messages de sortie
[Console]::SetOut([System.IO.StreamWriter]::Null)

$form.ShowDialog()
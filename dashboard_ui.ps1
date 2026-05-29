# ==============================================
# dashboard_ui.ps1
# Interface utilisateur du tableau de bord
# ==============================================

# --- FENÊTRE PRINCIPALE ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "MeetGay VPS Dashboard - $global:VPS_IP"
$form.Size = New-Object System.Drawing.Size(1400, 900)
$form.StartPosition = "CenterScreen"
$form.BackColor = "#1e1e2e"

# ==============================================
# PANEL GAUCHE
# ==============================================
$panelLeft = New-Object System.Windows.Forms.Panel
$panelLeft.Size = New-Object System.Drawing.Size(280, 850)
$panelLeft.Location = New-Object System.Drawing.Point(10, 40)
$panelLeft.BackColor = "#2d2d2d"
$form.Controls.Add($panelLeft)

$yPos = 10

# --- MONITORING ---
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

# --- LOGS ---
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

# --- CONTROLE VPS ---
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

# --- SECURITE ---
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
$yPos += 42

# --- BOUTON KILL SSH ---
$btnKillSSH = New-Object System.Windows.Forms.Button
$btnKillSSH.Text = "⚠️ KILL SSH (urgence)"
$btnKillSSH.Size = New-Object System.Drawing.Size(260, 35)
$btnKillSSH.Location = New-Object System.Drawing.Point(10, $yPos)
$btnKillSSH.BackColor = "#5a1a1a"
$btnKillSSH.ForeColor = "#ff8888"
$btnKillSSH.FlatStyle = "Flat"
$btnKillSSH.TextAlign = "MiddleLeft"
$panelLeft.Controls.Add($btnKillSSH)
$yPos += 52

# --- COMPTEUR PROCESSUS ---
$lblProcessCountTitle = New-Object System.Windows.Forms.Label
$lblProcessCountTitle.Text = "📊 Processus stream-logs :"
$lblProcessCountTitle.Size = New-Object System.Drawing.Size(260, 20)
$lblProcessCountTitle.Location = New-Object System.Drawing.Point(10, $yPos)
$lblProcessCountTitle.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$lblProcessCountTitle.ForeColor = "#cccccc"
$panelLeft.Controls.Add($lblProcessCountTitle)
$yPos += 22

$lblProcessCount = New-Object System.Windows.Forms.Label
$lblProcessCount.Text = "---"
$lblProcessCount.Size = New-Object System.Drawing.Size(260, 25)
$lblProcessCount.Location = New-Object System.Drawing.Point(10, $yPos)
$lblProcessCount.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$lblProcessCount.ForeColor = "#fbbf24"
$panelLeft.Controls.Add($lblProcessCount)
$yPos += 35

# --- BOUTON MODE AUTO/MANUEL ---
$btnAutoMode = New-Object System.Windows.Forms.Button
$btnAutoMode.Text = "🔄 MODE: AUTO"
$btnAutoMode.Size = New-Object System.Drawing.Size(260, 35)
$btnAutoMode.Location = New-Object System.Drawing.Point(10, $yPos)
$btnAutoMode.BackColor = "#1a3a1a"
$btnAutoMode.ForeColor = "#86efac"
$btnAutoMode.FlatStyle = "Flat"
$btnAutoMode.TextAlign = "MiddleLeft"
$panelLeft.Controls.Add($btnAutoMode)
$yPos += 52

# ==============================================
# PANEL STATUTS (LED + UPTIME)
# ==============================================
$panelStatus = New-Object System.Windows.Forms.Panel
$panelStatus.Size = New-Object System.Drawing.Size(1080, 100)
$panelStatus.Location = New-Object System.Drawing.Point(300, 40)
$panelStatus.BackColor = "#2d2d2d"
$form.Controls.Add($panelStatus)

$services = @("📦 meetgay", "🔐 sshd", "🌐 nginx", "🐘 postgresql", "🐘 php", "🛡️ fail2ban")
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
    $led.Location = New-Object System.Drawing.Point(10, 18)
    $led.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
    $card.Controls.Add($led)
    $ledLabels += $led
    
    $uptime = New-Object System.Windows.Forms.Label
    $uptime.Text = "---"
    $uptime.Size = New-Object System.Drawing.Size(110, 20)
    $uptime.Location = New-Object System.Drawing.Point(10, 48)
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

# --- ONGLET SYSTEME ---
$tabSysteme = New-Object System.Windows.Forms.TabPage
$tabSysteme.Text = "📊 SYSTEME"
$tabSysteme.BackColor = "#1e1e2e"
$tabControl.Controls.Add($tabSysteme)

$sysGroup = New-Object System.Windows.Forms.GroupBox
$sysGroup.Text = "📋 LOGS SYSTÈME"
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
$sysLogBox.Text = "[En attente...]`n"
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
$cmdBox.Text = "[En attente...]`n"
$cmdGroup.Controls.Add($cmdBox)

# --- ONGLET SERVICES ---
$tabServices = New-Object System.Windows.Forms.TabPage
$tabServices.Text = "🖥️ SERVICES"
$tabServices.BackColor = "#1e1e2e"
$tabControl.Controls.Add($tabServices)

# --- ONGLET CONFIGURATION ---
$tabConfig = New-Object System.Windows.Forms.TabPage
$tabConfig.Text = "⚙️ CONFIGURATION"
$tabConfig.BackColor = "#1e1e2e"
$tabControl.Controls.Add($tabConfig)

$configGroup = New-Object System.Windows.Forms.GroupBox
$configGroup.Text = "Paramètres du Dashboard"
$configGroup.Size = New-Object System.Drawing.Size(600, 300)
$configGroup.Location = New-Object System.Drawing.Point(20, 20)
$configGroup.ForeColor = "#ffffff"
$configGroup.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$tabConfig.Controls.Add($configGroup)

# Champ IP
$lblIP = New-Object System.Windows.Forms.Label
$lblIP.Text = "Adresse IP du VPS :"
$lblIP.Location = New-Object System.Drawing.Point(20, 50)
$lblIP.Size = New-Object System.Drawing.Size(150, 25)
$lblIP.ForeColor = "#ffffff"
$configGroup.Controls.Add($lblIP)

$txtIP = New-Object System.Windows.Forms.TextBox
$txtIP.Text = $global:VPS_IP
$txtIP.Location = New-Object System.Drawing.Point(180, 50)
$txtIP.Size = New-Object System.Drawing.Size(250, 25)
$configGroup.Controls.Add($txtIP)

# Champ clé SSH
$lblKey = New-Object System.Windows.Forms.Label
$lblKey.Text = "Chemin de la clé SSH :"
$lblKey.Location = New-Object System.Drawing.Point(20, 90)
$lblKey.Size = New-Object System.Drawing.Size(150, 25)
$lblKey.ForeColor = "#ffffff"
$configGroup.Controls.Add($lblKey)

$txtKey = New-Object System.Windows.Forms.TextBox
$txtKey.Text = $global:sshKey
$txtKey.Location = New-Object System.Drawing.Point(180, 90)
$txtKey.Size = New-Object System.Drawing.Size(400, 25)
$configGroup.Controls.Add($txtKey)

# Bouton Sauvegarder
$btnSaveConfig = New-Object System.Windows.Forms.Button
$btnSaveConfig.Text = "Sauvegarder"
$btnSaveConfig.Location = New-Object System.Drawing.Point(180, 140)
$btnSaveConfig.Size = New-Object System.Drawing.Size(120, 30)
$btnSaveConfig.BackColor = "#2a2a3e"
$btnSaveConfig.ForeColor = "#ffffff"
$btnSaveConfig.FlatStyle = "Flat"
$configGroup.Controls.Add($btnSaveConfig)

$btnSaveConfig.Add_Click({
    $newIP = $txtIP.Text
    $newKey = $txtKey.Text

    # Mettre à jour les variables globales
    $global:VPS_IP = $newIP
    $global:sshKey = $newKey

    # Sauvegarder dans dashboard_config.ps1
    $configFile = Join-Path $PSScriptRoot "dashboard_config.ps1"
    $lines = Get-Content $configFile
    $newLines = @()
    foreach ($line in $lines) {
        if ($line -match '^\$global:VPS_IP\s*=') {
            $newLines += "`$global:VPS_IP = `"$newIP`""
        } elseif ($line -match '^\$global:sshKey\s*=') {
            $newLines += "`$global:sshKey = `"$newKey`""
        } else {
            $newLines += $line
        }
    }
    $newLines | Set-Content -Path $configFile -Encoding UTF8

    $cmdBox.AppendText("[CONFIG] Paramètres sauvegardés dans dashboard_config.ps1`n")
})

$configGroup.Controls.Add($btnSaveConfig)

# ==============================================
# GRILLE DES 6 CARTES
# ==============================================
$gridLogs = New-Object System.Windows.Forms.Panel
$gridLogs.Size = New-Object System.Drawing.Size(1060, 660)
$gridLogs.Location = New-Object System.Drawing.Point(10, 10)
$gridLogs.BackColor = "transparent"
$tabServices.Controls.Add($gridLogs)

$cards = @()
$logBoxes = @()
$btnRefreshes = @()
$btnClears = @()
$btnActionses = @()
$btnZooms = @()
$btnCloses = @()

$servicesNames = @("📦 meetgay", "🔐 sshd", "🌐 nginx", "🐘 postgresql", "🐘 php", "🛡️ fail2ban")

for ($i = 0; $i -lt 6; $i++) {
    $x = if ($i -lt 3) { $i * 350 } else { ($i - 3) * 350 }
    $y = if ($i -lt 3) { 0 } else { 310 }
    
    $card = New-Object System.Windows.Forms.GroupBox
    $card.Text = ""
    $card.Size = New-Object System.Drawing.Size(340, 300)
    $card.Location = New-Object System.Drawing.Point($x, $y)
    $card.ForeColor = "#ffffff"
    $card.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $card.BackColor = "#0f172a"
    $gridLogs.Controls.Add($card)
    $cards += $card
    
    $logBox = New-Object System.Windows.Forms.RichTextBox
    $logBox.Anchor = "Top, Bottom, Left, Right"
    $logBox.Size = New-Object System.Drawing.Size(325, 250)
    $logBox.Location = New-Object System.Drawing.Point(5, 47)
    $logBox.BackColor = "#0a0f1a"
    $logBox.ForeColor = "#86efac"
    $logBox.Font = New-Object System.Drawing.Font("Consolas", 8)
    $logBox.Text = "[En attente...]`n"
    $card.Controls.Add($logBox)
    $logBoxes += $logBox
    
    # Bouton Actions (gauche)
    $btnActions = New-Object System.Windows.Forms.Button
    $btnActions.Text = "⚙️ Actions"
    $btnActions.Size = New-Object System.Drawing.Size(75, 25)
    $btnActions.Location = New-Object System.Drawing.Point(10, 15)
    $btnActions.BackColor = "#2a2a3e"
    $btnActions.ForeColor = "#ffffff"
    $btnActions.FlatStyle = "Flat"
    $card.Controls.Add($btnActions)
    $btnActionses += $btnActions
    
    # Titre centré
    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Text = $servicesNames[$i]
    $lblTitle.Size = New-Object System.Drawing.Size(120, 25)
    $lblTitle.Location = New-Object System.Drawing.Point(85, 15)
    $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $lblTitle.ForeColor = "#ffffff"
    $lblTitle.TextAlign = "MiddleCenter"
    $lblTitle.SendToBack()
    $card.Controls.Add($lblTitle)
    
    # Bouton Refresh (x=215)
    $btnRefresh = New-Object System.Windows.Forms.Button
    $btnRefresh.Text = "⟳"
    $btnRefresh.Size = New-Object System.Drawing.Size(35, 25)
    $btnRefresh.Location = New-Object System.Drawing.Point(215, 15)
    $btnRefresh.BackColor = "#1a3a1a"
    $btnRefresh.ForeColor = "#ffffff"
    $btnRefresh.FlatStyle = "Flat"
    #$btnRefresh.Anchor = "Top, Right"
    $card.Controls.Add($btnRefresh)
    $btnRefreshes += $btnRefresh

    # Bouton Zoom (x=255)
    $btnZoom = New-Object System.Windows.Forms.Button
    $btnZoom.Text = "⤢"
    $btnZoom.Size = New-Object System.Drawing.Size(35, 25)
    $btnZoom.Location = New-Object System.Drawing.Point(255, 15)
    $btnZoom.BackColor = "#3a3a6a"
    $btnZoom.ForeColor = "#ffffff"
    $btnZoom.FlatStyle = "Flat"
    #$btnZoom.Anchor = "Top, Right"
    $card.Controls.Add($btnZoom)
    $btnZooms += $btnZoom
    $btnZoom.Tag = $i

    # Bouton Clear (x=295)
    $btnClear = New-Object System.Windows.Forms.Button
    $btnClear.Text = "🗑"
    $btnClear.Size = New-Object System.Drawing.Size(35, 25)
    $btnClear.Location = New-Object System.Drawing.Point(295, 15)
    $btnClear.BackColor = "#3a1a1a"
    $btnClear.ForeColor = "#ffffff"
    $btnClear.FlatStyle = "Flat"
    $card.Controls.Add($btnClear)
    $btnClears += $btnClear
    
    # Bouton Close (zoom)
    $btnClose = New-Object System.Windows.Forms.Button
    $btnClose.Text = "✕"
    $btnClose.Size = New-Object System.Drawing.Size(35, 25)
    $btnClose.Location = New-Object System.Drawing.Point(10, 15)
    $btnClose.Visible = $false
    #$btnClose.Anchor = "Top, Left"
    $card.Controls.Add($btnClose)
    $btnCloses += $btnClose
    
    # Stocker les références dans Tag
    $card.Tag = @{
    LogBox = $logBox
    BtnZoom = $btnZoom
    BtnClose = $btnClose
    BtnRefresh = $btnRefresh
    BtnClear = $btnClear
    Index = $i
    }  
}

# ==============================================
# HORLOGE
# ==============================================
$clock = New-Object System.Windows.Forms.Label
$clock.Size = New-Object System.Drawing.Size(200, 30)
$clock.Location = New-Object System.Drawing.Point(1180, 5)
$clock.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$clock.ForeColor = "#86efac"
$clock.TextAlign = "MiddleRight"
$form.Controls.Add($clock)

$clockTimer = New-Object System.Windows.Forms.Timer
$clockTimer.Interval = 1000
$clockTimer.Add_Tick({ $clock.Text = Get-Date -Format "HH:mm:ss" })
$clockTimer.Start()

# ==============================================
# FERMETURE PROPRE
# ==============================================
$form.Add_FormClosing({
    $script:isClosing = $true
    $clockTimer.Stop()
    Stop-GlobalStream
    Kill-AllSSH
    [System.Environment]::Exit(0)
})
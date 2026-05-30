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
# PANEL GAUCHE (réorganisé)
# ==============================================
$panelLeft = New-Object System.Windows.Forms.Panel
$panelLeft.Size = New-Object System.Drawing.Size(280, 850)
$panelLeft.Location = New-Object System.Drawing.Point(10, 40)
$panelLeft.BackColor = "#2d2d2d"
$form.Controls.Add($panelLeft)

$yPos = 10

# --- 1. KILL SSH (urgence) ---
$groupKill = New-Object System.Windows.Forms.GroupBox
$groupKill.Text = "⚠️ URGENCE"
$groupKill.Size = New-Object System.Drawing.Size(260, 70)
$groupKill.Location = New-Object System.Drawing.Point(10, $yPos)
$groupKill.ForeColor = "#ff8888"
$groupKill.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$groupKill.BackColor = "#1e1e2e"
$panelLeft.Controls.Add($groupKill)
$btnKillSSH = New-Object System.Windows.Forms.Button
$btnKillSSH.Text = "⚠️ KILL SSH (urgence)"
$btnKillSSH.Size = New-Object System.Drawing.Size(240, 35)
$btnKillSSH.Location = New-Object System.Drawing.Point(10, 20)
$btnKillSSH.BackColor = "#5a1a1a"
$btnKillSSH.ForeColor = "#ff8888"
$btnKillSSH.FlatStyle = "Flat"
$btnKillSSH.TextAlign = "MiddleLeft"
$groupKill.Controls.Add($btnKillSSH)
$yPos += 80

# --- 2. CONTROLE VPS ---
$groupControl = New-Object System.Windows.Forms.GroupBox
$groupControl.Text = "🔧 CONTROLE VPS"
$groupControl.Size = New-Object System.Drawing.Size(260, 110)
$groupControl.Location = New-Object System.Drawing.Point(10, $yPos)
$groupControl.ForeColor = "#88c0d0"
$groupControl.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$groupControl.BackColor = "#1e1e2e"
$panelLeft.Controls.Add($groupControl)
$btnReboot = New-Object System.Windows.Forms.Button
$btnReboot.Text = "🔄 Reboot VPS (doux)"
$btnReboot.Size = New-Object System.Drawing.Size(240, 35)
$btnReboot.Location = New-Object System.Drawing.Point(10, 25)
$btnReboot.BackColor = "#3a2a1a"
$btnReboot.ForeColor = "#ffffff"
$btnReboot.FlatStyle = "Flat"
$btnReboot.TextAlign = "MiddleLeft"
$groupControl.Controls.Add($btnReboot)
$btnForceReboot = New-Object System.Windows.Forms.Button
$btnForceReboot.Text = "⚠️ Force reboot"
$btnForceReboot.Size = New-Object System.Drawing.Size(240, 35)
$btnForceReboot.Location = New-Object System.Drawing.Point(10, 65)
$btnForceReboot.BackColor = "#3a1a1a"
$btnForceReboot.ForeColor = "#ff8888"
$btnForceReboot.FlatStyle = "Flat"
$btnForceReboot.TextAlign = "MiddleLeft"
$groupControl.Controls.Add($btnForceReboot)
$yPos += 120

# --- 3. SECURITE ---
$groupSecurite = New-Object System.Windows.Forms.GroupBox
$groupSecurite.Text = "🔒 SECURITE"
$groupSecurite.Size = New-Object System.Drawing.Size(260, 70)
$groupSecurite.Location = New-Object System.Drawing.Point(10, $yPos)
$groupSecurite.ForeColor = "#88c0d0"
$groupSecurite.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$groupSecurite.BackColor = "#1e1e2e"
$panelLeft.Controls.Add($groupSecurite)
$btnSecurite = New-Object System.Windows.Forms.Button
$btnSecurite.Text = "Securite (Fail2ban)"
$btnSecurite.Size = New-Object System.Drawing.Size(240, 35)
$btnSecurite.Location = New-Object System.Drawing.Point(10, 25)
$btnSecurite.BackColor = "#000000"
$btnSecurite.ForeColor = "#ffffff"
$btnSecurite.FlatStyle = "Flat"
$btnSecurite.TextAlign = "MiddleLeft"
$groupSecurite.Controls.Add($btnSecurite)
$yPos += 80

# --- 4. LOGS ---
$groupLogs = New-Object System.Windows.Forms.GroupBox
$groupLogs.Text = "📜 LOGS"
$groupLogs.Size = New-Object System.Drawing.Size(260, 110)
$groupLogs.Location = New-Object System.Drawing.Point(10, $yPos)
$groupLogs.ForeColor = "#88c0d0"
$groupLogs.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$groupLogs.BackColor = "#1e1e2e"
$panelLeft.Controls.Add($groupLogs)
$btnLogsSimple = New-Object System.Windows.Forms.Button
$btnLogsSimple.Text = "Logs (simple)"
$btnLogsSimple.Size = New-Object System.Drawing.Size(240, 35)
$btnLogsSimple.Location = New-Object System.Drawing.Point(10, 25)
$btnLogsSimple.BackColor = "#000000"
$btnLogsSimple.ForeColor = "#ffffff"
$btnLogsSimple.FlatStyle = "Flat"
$btnLogsSimple.TextAlign = "MiddleLeft"
$groupLogs.Controls.Add($btnLogsSimple)
$btnLogsRealtime = New-Object System.Windows.Forms.Button
$btnLogsRealtime.Text = "📡 Logs (temps réel)"
$btnLogsRealtime.Size = New-Object System.Drawing.Size(240, 35)
$btnLogsRealtime.Location = New-Object System.Drawing.Point(10, 65)
$btnLogsRealtime.BackColor = "#1a3a1a"
$btnLogsRealtime.ForeColor = "#86efac"
$btnLogsRealtime.FlatStyle = "Flat"
$btnLogsRealtime.TextAlign = "MiddleLeft"
$groupLogs.Controls.Add($btnLogsRealtime)
$yPos += 120

# --- 5. COMPTEUR PROCESSUS ---
$groupProcess = New-Object System.Windows.Forms.GroupBox
$groupProcess.Text = "📊 PROCESSUS"
$groupProcess.Size = New-Object System.Drawing.Size(260, 80)
$groupProcess.Location = New-Object System.Drawing.Point(10, $yPos)
$groupProcess.ForeColor = "#88c0d0"
$groupProcess.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$groupProcess.BackColor = "#1e1e2e"
$panelLeft.Controls.Add($groupProcess)
$lblProcessCountTitle = New-Object System.Windows.Forms.Label
$lblProcessCountTitle.Text = "stream-logs.sh :"
$lblProcessCountTitle.Size = New-Object System.Drawing.Size(240, 20)
$lblProcessCountTitle.Location = New-Object System.Drawing.Point(10, 22)
$lblProcessCountTitle.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$lblProcessCountTitle.ForeColor = "#cccccc"
$groupProcess.Controls.Add($lblProcessCountTitle)
$lblProcessCount = New-Object System.Windows.Forms.Label
$lblProcessCount.Text = "---"
$lblProcessCount.Size = New-Object System.Drawing.Size(240, 30)
$lblProcessCount.Location = New-Object System.Drawing.Point(10, 45)
$lblProcessCount.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$lblProcessCount.ForeColor = "#fbbf24"
$groupProcess.Controls.Add($lblProcessCount)
$yPos += 90

# --- 6. MODE AUTO/MANUEL ---
$groupMode = New-Object System.Windows.Forms.GroupBox
$groupMode.Text = "🎮 MODE"
$groupMode.Size = New-Object System.Drawing.Size(260, 70)
$groupMode.Location = New-Object System.Drawing.Point(10, $yPos)
$groupMode.ForeColor = "#88c0d0"
$groupMode.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$groupMode.BackColor = "#1e1e2e"
$panelLeft.Controls.Add($groupMode)
$btnAutoMode = New-Object System.Windows.Forms.Button
$btnAutoMode.Text = "🔄 MODE: AUTO"
$btnAutoMode.Size = New-Object System.Drawing.Size(240, 35)
$btnAutoMode.Location = New-Object System.Drawing.Point(10, 25)
$btnAutoMode.BackColor = "#1a3a1a"
$btnAutoMode.ForeColor = "#86efac"
$btnAutoMode.FlatStyle = "Flat"
$btnAutoMode.TextAlign = "MiddleLeft"
$groupMode.Controls.Add($btnAutoMode)
$yPos += 80

# --- 7. MONITORING ---
$groupMonitoring = New-Object System.Windows.Forms.GroupBox
$groupMonitoring.Text = "📊 MONITORING"
$groupMonitoring.Size = New-Object System.Drawing.Size(260, 110)
$groupMonitoring.Location = New-Object System.Drawing.Point(10, $yPos)
$groupMonitoring.ForeColor = "#88c0d0"
$groupMonitoring.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$groupMonitoring.BackColor = "#1e1e2e"
$panelLeft.Controls.Add($groupMonitoring)
$btnMonitoring = New-Object System.Windows.Forms.Button
$btnMonitoring.Text = "Monitoring complet"
$btnMonitoring.Size = New-Object System.Drawing.Size(240, 35)
$btnMonitoring.Location = New-Object System.Drawing.Point(10, 25)
$btnMonitoring.BackColor = "#000000"
$btnMonitoring.ForeColor = "#ffffff"
$btnMonitoring.FlatStyle = "Flat"
$btnMonitoring.TextAlign = "MiddleLeft"
$groupMonitoring.Controls.Add($btnMonitoring)
$btnStatus = New-Object System.Windows.Forms.Button
$btnStatus.Text = "Status rapide"
$btnStatus.Size = New-Object System.Drawing.Size(240, 35)
$btnStatus.Location = New-Object System.Drawing.Point(10, 65)
$btnStatus.BackColor = "#000000"
$btnStatus.ForeColor = "#ffffff"
$btnStatus.FlatStyle = "Flat"
$btnStatus.TextAlign = "MiddleLeft"
$groupMonitoring.Controls.Add($btnStatus)
$yPos += 120

# ==============================================
# PANEL STATUTS (LED + UPTIME + CPU/RAM)
# ==============================================
$panelStatus = New-Object System.Windows.Forms.Panel
$panelStatus.Size = New-Object System.Drawing.Size(1080, 100)
$panelStatus.Location = New-Object System.Drawing.Point(300, 40)
$panelStatus.BackColor = "#2d2d2d"
$form.Controls.Add($panelStatus)

$services = @("📊 CPU/RAM", "📦 meetgay", "👤 systemd-logind", "🌐 nginx", "🐘 postgresql", "🐘 php", "🛡️ fail2ban")
$ledLabels = @()
$uptimeLabels = @()

for ($i = 0; $i -lt $services.Length; $i++) {
    $x = 10 + ($i * 140)
    $card = New-Object System.Windows.Forms.GroupBox
    $card.Text = $services[$i]
    $card.Size = New-Object System.Drawing.Size(130, 85)
    $card.Location = New-Object System.Drawing.Point($x, 10)
    $card.ForeColor = "#ffffff"
    $card.BackColor = "#1a1a2e"
    $panelStatus.Controls.Add($card)
    
    if ($i -eq 0) {
        # Carte CPU/RAM : deux lignes
        $cpuValue = New-Object System.Windows.Forms.Label
        $cpuValue.Text = "CPU: --"
        $cpuValue.Size = New-Object System.Drawing.Size(110, 25)
        $cpuValue.Location = New-Object System.Drawing.Point(10, 20)
        $cpuValue.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
        $cpuValue.ForeColor = "#86efac"
        $card.Controls.Add($cpuValue)
        
        $ramValue = New-Object System.Windows.Forms.Label
        $ramValue.Text = "RAM: --"
        $ramValue.Size = New-Object System.Drawing.Size(110, 25)
        $ramValue.Location = New-Object System.Drawing.Point(10, 50)
        $ramValue.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
        $ramValue.ForeColor = "#86efac"
        $card.Controls.Add($ramValue)
        
        # Stocker les références globales
        $global:cpuLabel = $cpuValue
        $global:ramLabel = $ramValue
        
        # Ajouter des placeholders pour garder les indices cohérents
        $ledLabels += $null
        $uptimeLabels += $null
    } else {
        # Cartes normales : LED + uptime
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

# Bouton Sauvegarder IP
$btnSaveIP = New-Object System.Windows.Forms.Button
$btnSaveIP.Text = "Sauvegarder IP"
$btnSaveIP.Location = New-Object System.Drawing.Point(440, 50)
$btnSaveIP.Size = New-Object System.Drawing.Size(120, 25)
$btnSaveIP.BackColor = "#2a2a3e"
$btnSaveIP.ForeColor = "#ffffff"
$btnSaveIP.FlatStyle = "Flat"
$configGroup.Controls.Add($btnSaveIP)

$btnSaveIP.Add_Click({
    $nouvelleIP = $txtIP.Text
    $configFile = Join-Path $PSScriptRoot "dashboard_config.ps1"
    $contenu = Get-Content $configFile -Raw
    $ancienneLigne = "`$global:VPS_IP = `"$global:VPS_IP`""
    $nouvelleLigne = "`$global:VPS_IP = `"$nouvelleIP`""
    $nouveauContenu = $contenu.Replace($ancienneLigne, $nouvelleLigne)
    $nouveauContenu | Set-Content $configFile -Encoding UTF8
    $global:VPS_IP = $nouvelleIP
    $cmdBox.AppendText("[CONFIG] IP sauvegardée : $nouvelleIP`n")
})

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

# Bouton Sauvegarder Clé SSH
$btnSaveKey = New-Object System.Windows.Forms.Button
$btnSaveKey.Text = "Sauvegarder clé"
$btnSaveKey.Location = New-Object System.Drawing.Point(590, 90)
$btnSaveKey.Size = New-Object System.Drawing.Size(120, 25)
$btnSaveKey.BackColor = "#2a2a3e"
$btnSaveKey.ForeColor = "#ffffff"
$btnSaveKey.FlatStyle = "Flat"
$configGroup.Controls.Add($btnSaveKey)

$btnSaveKey.Add_Click({
    $nouvelleCle = $txtKey.Text
    $configFile = Join-Path $PSScriptRoot "dashboard_config.ps1"
    $contenu = Get-Content $configFile -Raw
    $ancienneLigne = "`$global:sshKey = `"$global:sshKey`""
    $nouvelleLigne = "`$global:sshKey = `"$nouvelleCle`""
    $nouveauContenu = $contenu.Replace($ancienneLigne, $nouvelleLigne)
    $nouveauContenu | Set-Content $configFile -Encoding UTF8
    $global:sshKey = $nouvelleCle
    $cmdBox.AppendText("[CONFIG] Clé SSH sauvegardée : $nouvelleCle`n")
})


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

$servicesNames = @("📦 meetgay", "👤 systemd-logind", "🌐 nginx", "🐘 postgresql", "🐘 php", "🛡️ fail2ban")

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
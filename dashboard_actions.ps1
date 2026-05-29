# ==============================================
# dashboard_actions.ps1
# Actions : refresh, clear, menus contextuels, boutons gauche
# ==============================================

# ==============================================
# BOUTONS REFRESH ET CLEAR PAR CARTE
# ==============================================
# meetgay (index 0)
$btnRefreshes[0].Add_Click({
    $logBoxes[0].Clear()
    $logBoxes[0].AppendText("===== LOGS MEETGAY =====`n[REFRESH] Logs effacés`n")
})
$btnClears[0].Add_Click({
    $logBoxes[0].Clear()
    $logBoxes[0].AppendText("===== LOGS MEETGAY =====`n[CLEAR] Logs effacés`n")
})

# sshd (index 1)
$btnRefreshes[1].Add_Click({
    $logBoxes[1].Clear()
    $logBoxes[1].AppendText("===== LOGS SSHD =====`n[REFRESH] Logs effacés`n")
    if (-not $script:streamActive) { Start-GlobalStream }
})
$btnClears[1].Add_Click({
    $logBoxes[1].Clear()
    $logBoxes[1].AppendText("===== LOGS SSHD =====`n[CLEAR] Logs effacés`n")
})

# nginx (index 2)
$btnRefreshes[2].Add_Click({
    $logBoxes[2].Clear()
    $logBoxes[2].AppendText("===== LOGS NGINX =====`n[REFRESH] Logs effacés`n")
    if (-not $script:streamActive) { Start-GlobalStream }
})
$btnClears[2].Add_Click({
    $logBoxes[2].Clear()
    $logBoxes[2].AppendText("===== LOGS NGINX =====`n[CLEAR] Logs effacés`n")
})

# postgresql (index 3)
$btnRefreshes[3].Add_Click({
    $logBoxes[3].Clear()
    $logBoxes[3].AppendText("===== LOGS POSTGRESQL =====`n[REFRESH] Logs effacés`n")
    if (-not $script:streamActive) { Start-GlobalStream }
})
$btnClears[3].Add_Click({
    $logBoxes[3].Clear()
    $logBoxes[3].AppendText("===== LOGS POSTGRESQL =====`n[CLEAR] Logs effacés`n")
})

# php (index 4)
$btnRefreshes[4].Add_Click({
    $logBoxes[4].Clear()
    $logBoxes[4].AppendText("===== LOGS PHP =====`n[REFRESH] Logs effacés`n")
    if (-not $script:streamActive) { Start-GlobalStream }
})
$btnClears[4].Add_Click({
    $logBoxes[4].Clear()
    $logBoxes[4].AppendText("===== LOGS PHP =====`n[CLEAR] Logs effacés`n")
})

# fail2ban (index 5)
$btnRefreshes[5].Add_Click({
    $logBoxes[5].Clear()
    $logBoxes[5].AppendText("===== LOGS FAIL2BAN =====`n[REFRESH] Logs effacés`n")
    if (-not $script:streamActive) { Start-GlobalStream }
})
$btnClears[5].Add_Click({
    $logBoxes[5].Clear()
    $logBoxes[5].AppendText("===== LOGS FAIL2BAN =====`n[CLEAR] Logs effacés`n")
})

# ==============================================
# MENUS ACTIONS (individuels, sans boucle)
# ==============================================

# ----- meetgay (pm2) -----
$menuMeetgay = New-Object System.Windows.Forms.ContextMenuStrip
$menuMeetgay.BackColor = "#18191a"
$menuMeetgay.ForeColor = "White"
$menuMeetgay.ShowImageMargin = $false
$menuMeetgay.Padding = 0
foreach ($action in @("start","stop","restart","gracefulReload","monit","flush","save")) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $action
    $item.BackColor = "#18191a"
    $item.ForeColor = "White"
    $item.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $item.Padding = 0
    $item.Margin = 0
    $item.Add_Click({
        $cmdBox.AppendText("[ACTION] meetgay - $action`n")
        Write-DebugLog "Action $action sur meetgay"
Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "pm2 $action meetgay 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null    })
    $menuMeetgay.Items.Add($item)
}
$btnActionses[0].Add_Click({ $menuMeetgay.Show($btnActionses[0], 0, $btnActionses[0].Height) })

# ----- sshd (systemd) -----
$menuSshd = New-Object System.Windows.Forms.ContextMenuStrip
$menuSshd.BackColor = "#18191a"
$menuSshd.ForeColor = "White"
$menuSshd.ShowImageMargin = $false
$menuSshd.Padding = 0
foreach ($action in @("start","stop","restart")) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $action
    $item.BackColor = "#18191a"
    $item.ForeColor = "White"
    $item.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $item.Padding = 0
    $item.Margin = 0
    $item.Add_Click({
        $cmdBox.AppendText("[ACTION] sshd - $action`n")
        Write-DebugLog "Action $action sur sshd"
Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "systemctl $action sshd 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null    })
    $menuSshd.Items.Add($item)
}
$btnActionses[1].Add_Click({ $menuSshd.Show($btnActionses[1], 0, $btnActionses[1].Height) })

# ----- nginx (systemd) -----
$menuNginx = New-Object System.Windows.Forms.ContextMenuStrip
$menuNginx.BackColor = "#18191a"
$menuNginx.ForeColor = "White"
$menuNginx.ShowImageMargin = $false
$menuNginx.Padding = 0
foreach ($action in @("start","stop","restart","reload")) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $action
    $item.BackColor = "#18191a"
    $item.ForeColor = "White"
    $item.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $item.Padding = 0
    $item.Margin = 0
    $item.Add_Click({
        $cmdBox.AppendText("[ACTION] nginx - $action`n")
        Write-DebugLog "Action $action sur nginx"
Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "systemctl $action nginx 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null    })
    $menuNginx.Items.Add($item)
}
$btnActionses[2].Add_Click({ $menuNginx.Show($btnActionses[2], 0, $btnActionses[2].Height) })

# ----- postgresql (systemd) -----
$menuPostgresql = New-Object System.Windows.Forms.ContextMenuStrip
$menuPostgresql.BackColor = "#18191a"
$menuPostgresql.ForeColor = "White"
$menuPostgresql.ShowImageMargin = $false
$menuPostgresql.Padding = 0
foreach ($action in @("start","stop","restart")) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $action
    $item.BackColor = "#18191a"
    $item.ForeColor = "White"
    $item.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $item.Padding = 0
    $item.Margin = 0
    $item.Add_Click({
        $cmdBox.AppendText("[ACTION] postgresql - $action`n")
        Write-DebugLog "Action $action sur postgresql"
Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "systemctl $action postgresql 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null    })
    $menuPostgresql.Items.Add($item)
}
$btnActionses[3].Add_Click({ $menuPostgresql.Show($btnActionses[3], 0, $btnActionses[3].Height) })

# ----- php8.3-fpm (systemd) -----
$menuPhp = New-Object System.Windows.Forms.ContextMenuStrip
$menuPhp.BackColor = "#18191a"
$menuPhp.ForeColor = "White"
$menuPhp.ShowImageMargin = $false
$menuPhp.Padding = 0
foreach ($action in @("start","stop","restart")) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $action
    $item.BackColor = "#18191a"
    $item.ForeColor = "White"
    $item.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $item.Padding = 0
    $item.Margin = 0
    $item.Add_Click({
        $cmdBox.AppendText("[ACTION] php8.3-fpm - $action`n")
        Write-DebugLog "Action $action sur php8.3-fpm"
Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "systemctl $action php8.3-fpm 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null    })
    $menuPhp.Items.Add($item)
}
$btnActionses[4].Add_Click({ $menuPhp.Show($btnActionses[4], 0, $btnActionses[4].Height) })

# ----- fail2ban (systemd) -----
$menuFail2ban = New-Object System.Windows.Forms.ContextMenuStrip
$menuFail2ban.BackColor = "#18191a"
$menuFail2ban.ForeColor = "White"
$menuFail2ban.ShowImageMargin = $false
$menuFail2ban.Padding = 0
foreach ($action in @("start","stop","restart","reload","status")) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $action
    $item.BackColor = "#18191a"
    $item.ForeColor = "White"
    $item.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $item.Padding = 0
    $item.Margin = 0
    $item.Add_Click({
        $cmdBox.AppendText("[ACTION] fail2ban - $action`n")
        Write-DebugLog "Action $action sur fail2ban"
Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "systemctl $action fail2ban 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null    })
    $menuFail2ban.Items.Add($item)
}
$btnActionses[5].Add_Click({ $menuFail2ban.Show($btnActionses[5], 0, $btnActionses[5].Height) })

# ==============================================
# BOUTONS DU PANEL GAUCHE
# ==============================================
$btnMonitoring.Add_Click({
    $cmdBox.AppendText("=== MONITORING COMPLET ===`n")
Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "/root/panel-api.sh full 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null})

$btnStatus.Add_Click({
    $cmdBox.AppendText("=== STATUS RAPIDE ===`n")
Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "/root/panel-api.sh status 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null})

$btnLogsSimple.Add_Click({
    $cmdBox.AppendText("=== DERNIERS LOGS ===`n")
    Start-Job -Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "/root/panel-api.sh logs 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null { param($ip) ssh root@$ip "/root/panel-api.sh logs 2>&1" } -ArgumentList $global:VPS_IP | Out-Null
})

$btnLogsRealtime.Add_Click({
    $cmdBox.AppendText("[LOGS] Streaming automatique actif`n")
})

$btnReboot.Add_Click({
    $cmdBox.AppendText("[REBOOT] Redémarrage dans 1 minute...`n")
Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "/root/panel-api.sh reboot 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null})

$btnForceReboot.Add_Click({
    $cmdBox.AppendText("[FORCE REBOOT] Redémarrage immédiat...`n")
Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "/root/panel-api.sh reboot-force 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null})
$btnSecurite.Add_Click({
    $cmdBox.AppendText("=== FAIL2BAN STATUS ===`n")
Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "/root/panel-api.sh security 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null})

$btnKillSSH.Add_Click({
    Kill-AllSSH
    $cmdBox.AppendText("[KILL] Connexion SSH du dashboard fermée`n")
})

$btnAutoMode.Add_Click({
    $script:autoMode = -not $script:autoMode
    if ($script:autoMode) {
        $btnAutoMode.Text = "🔄 MODE: AUTO"
        $btnAutoMode.BackColor = "#1a3a1a"
        $btnAutoMode.ForeColor = "#86efac"
        Start-GlobalStream
        $cmdBox.AppendText("[MODE] AUTO - logs démarrés`n")
    } else {
        $btnAutoMode.Text = "⏹️ MODE: MANUEL"
        $btnAutoMode.BackColor = "#3a1a1a"
        $btnAutoMode.ForeColor = "#f87171"
        Stop-GlobalStream
        $cmdBox.AppendText("[MODE] MANUEL - logs arrêtés`n")
    }
})
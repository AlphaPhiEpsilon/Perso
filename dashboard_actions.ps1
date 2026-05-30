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

# logind (index 1)
$btnRefreshes[1].Add_Click({
    $logBoxes[1].Clear()
    $logBoxes[1].AppendText("===== LOGS LOGIN =====`n[REFRESH] Logs effacés`n")
    if (-not $script:streamActive) { Start-GlobalStream }
})
$btnClears[1].Add_Click({
    $logBoxes[1].Clear()
    $logBoxes[1].AppendText("===== LOGS LOGIN =====`n[CLEAR] Logs effacés`n")
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

# ----- meetgay (pm2) - carte 0 : commandes -----
$menuMeetgay = New-Object System.Windows.Forms.ContextMenuStrip
$menuMeetgay.BackColor = "#18191a"
$menuMeetgay.ForeColor = "White"
$menuMeetgay.ShowImageMargin = $false
$menuMeetgay.Padding = 0

# Liste des actions (sans status)
$actionsMeetgay = @("start","stop","restart","gracefulReload","flush","save")

foreach ($action in $actionsMeetgay) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $action
    $item.BackColor = "#18191a"
    $item.ForeColor = "White"
    $item.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $item.Padding = 0
    $item.Margin = 0
    $item.Tag = $action
    $item.Add_Click({
        $act = $this.Tag
        $logBoxes[0].AppendText("> pm2 $act meetgay`n")
        $logBoxes[0].ScrollToCaret()
        $result = ssh -i $global:sshKey root@$global:VPS_IP "pm2 $act meetgay 2>&1"
        if ($result) {
            $clean = $result -replace '[^\x00-\x7F]', ''
            $lines = $clean -split "`n"
            $filtered = $lines | Where-Object { $_ -match '\[PM2\]' }
            if ($filtered.Count -gt 0) {
                $logBoxes[0].AppendText(($filtered -join "`n") + "`n")
            } else {
                $firstLine = $lines | Where-Object { $_.Trim() -ne "" } | Select-Object -First 1
                if ($firstLine) { $logBoxes[0].AppendText($firstLine + "`n") }
                else { $logBoxes[0].AppendText("(Commande exécutée)`n") }
            }
        } else {
            $logBoxes[0].AppendText("(Commande exécutée sans sortie)`n")
        }
        $logBoxes[0].ScrollToCaret()
    })
    $menuMeetgay.Items.Add($item)
}

# ----- Ajout du séparateur + status -----
$separator = New-Object System.Windows.Forms.ToolStripSeparator
$menuMeetgay.Items.Add($separator)

$statusItem = New-Object System.Windows.Forms.ToolStripMenuItem
$statusItem.Text = "status"
$statusItem.BackColor = "#18191a"
$statusItem.ForeColor = "White"
$statusItem.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$statusItem.Padding = 0
$statusItem.Margin = 0
$statusItem.Add_Click({
    $logBoxes[0].AppendText("> pm2 list (status)`n")
    $logBoxes[0].ScrollToCaret()
    $result = ssh -i $global:sshKey root@$global:VPS_IP "pm2 list 2>&1"
    if ($result) {
        $clean = $result -replace '[^\x00-\x7F]', ''
        $lines = $clean -split "`n"
        # Trouver l'en-tête et les lignes de données
        $headerLine = $lines | Where-Object { $_ -match 'id.*name.*mode' } | Select-Object -First 1
        $dataLines = $lines | Where-Object { $_ -match '^\s*\d+\s+' }
        if ($headerLine -and $dataLines) {
            # Extraire les colonnes souhaitées (id, name, mode, pid, uptime, status, cpu, mem)
            $headerParts = $headerLine -split '\s{2,}' | Where-Object { $_ -ne '' }
            # Indices approximatifs (à ajuster selon la sortie réelle)
            $idx_id = 0
            $idx_name = 1
            $idx_mode = 4
            $idx_pid = 5
            $idx_uptime = 6
            $idx_status = 8
            $idx_cpu = 9
            $idx_mem = 10
            # Construire l'en-tête simplifié
            $logBoxes[0].AppendText(("{0,-3} {1,-12} {2,-6} {3,-7} {4,-7} {5,-8} {6,-5} {7,-8}" -f "ID","NAME","MODE","PID","UPTIME","STATUS","CPU","MEM") + "`n")
            $logBoxes[0].AppendText(("{0,-3} {1,-12} {2,-6} {3,-7} {4,-7} {5,-8} {6,-5} {7,-8}" -f "---","----","----","---","------","------","---","---") + "`n")
            foreach ($line in $dataLines) {
                $parts = $line -split '\s{2,}' | Where-Object { $_ -ne '' }
                if ($parts.Count -ge 11) {
                    $id = $parts[$idx_id]
                    $name = $parts[$idx_name]
                    $mode = $parts[$idx_mode]
                    $pid = $parts[$idx_pid]
                    $uptime = $parts[$idx_uptime]
                    $status = $parts[$idx_status]
                    $cpu = $parts[$idx_cpu]
                    $mem = $parts[$idx_mem]
                    $logBoxes[0].AppendText(("{0,-3} {1,-12} {2,-6} {3,-7} {4,-7} {5,-8} {6,-5} {7,-8}" -f $id, $name, $mode, $pid, $uptime, $status, $cpu, $mem) + "`n")
                }
            }
        } else {
            $logBoxes[0].AppendText("Aucune donnée`n")
        }
    } else {
        $logBoxes[0].AppendText("Impossible de récupérer le statut`n")
    }
    $logBoxes[0].ScrollToCaret()
})
$menuMeetgay.Items.Add($statusItem)

$btnActionses[0].Add_Click({ $menuMeetgay.Show($btnActionses[0], 0, $btnActionses[0].Height) })


# ----- systemd-logind (systemd) - carte 1 -----
$menuLogind = New-Object System.Windows.Forms.ContextMenuStrip
$menuLogind.BackColor = "#18191a"
$menuLogind.ForeColor = "White"
$menuLogind.ShowImageMargin = $false
$menuLogind.Padding = 0

$actionsLogind = @("start","stop","restart")
foreach ($action in $actionsLogind) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $action
    $item.BackColor = "#18191a"
    $item.ForeColor = "White"
    $item.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $item.Padding = 0
    $item.Margin = 0
    $item.Tag = $action
    $item.Add_Click({
        $act = $this.Tag
        $logBoxes[1].AppendText("> systemctl $act systemd-logind`n")
        $logBoxes[1].ScrollToCaret()
        ssh -i $global:sshKey root@$global:VPS_IP "systemctl $act systemd-logind" 2>&1 | Out-Null
        $logBoxes[1].AppendText("(commande envoyée, voir les logs pour le résultat)`n")
        $logBoxes[1].ScrollToCaret()
    })
    $menuLogind.Items.Add($item)
}

$separator = New-Object System.Windows.Forms.ToolStripSeparator
$menuLogind.Items.Add($separator)

$statusItem = New-Object System.Windows.Forms.ToolStripMenuItem
$statusItem.Text = "status"
$statusItem.BackColor = "#18191a"
$statusItem.ForeColor = "White"
$statusItem.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$statusItem.Padding = 0
$statusItem.Margin = 0
$statusItem.Add_Click({
    $logBoxes[1].AppendText("> systemctl status systemd-logind (résumé)`n")
    $logBoxes[1].ScrollToCaret()
    $result = ssh -i $global:sshKey root@$global:VPS_IP "systemctl show systemd-logind --property=Names,LoadState,ActiveState,SubState,MainPID,MemoryCurrent 2>&1"
    if ($result) {
        $clean = $result -replace '[^\x00-\x7F]', ''
        $data = @{}
        $clean -split "`n" | ForEach-Object {
            if ($_ -match '^([^=]+)=(.*)$') { $data[$matches[1]] = $matches[2] }
        }
        $name = $data['Names'] -replace '\.service',''
        $load = $data['LoadState']
        $active = $data['ActiveState']
        $sub = $data['SubState']
        $mainPid = if ($data['MainPID'] -eq 0) { "aucun" } else { $data['MainPID'] }
        $mem = if ($data['MemoryCurrent'] -gt 0) { "$([math]::Round($data['MemoryCurrent']/1MB,1)) MB" } else { "n/a" }
        $logBoxes[1].AppendText("Service : $name`n")
        $logBoxes[1].AppendText("Loaded  : $load`n")
        $logBoxes[1].AppendText("Active  : $active ($sub)`n")
        $logBoxes[1].AppendText("Main PID: $mainPid`n")
        $logBoxes[1].AppendText("Memory  : $mem`n")
    } else {
        $logBoxes[1].AppendText("Impossible de récupérer le statut`n")
    }
    $logBoxes[1].ScrollToCaret()
})
$menuLogind.Items.Add($statusItem)

$btnActionses[1].Add_Click({ $menuLogind.Show($btnActionses[1], 0, $btnActionses[1].Height) })

# ----- nginx (systemd) - carte 2 (version corrigée) -----
$menuNginx = New-Object System.Windows.Forms.ContextMenuStrip
$menuNginx.BackColor = "#18191a"
$menuNginx.ForeColor = "White"
$menuNginx.ShowImageMargin = $false
$menuNginx.Padding = 0

$actionsNginx = @("start","stop","restart","reload")
foreach ($action in $actionsNginx) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $action
    $item.BackColor = "#18191a"
    $item.ForeColor = "White"
    $item.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $item.Padding = 0
    $item.Margin = 0
    $item.Tag = $action
    $item.Add_Click({
        $act = $this.Tag
        $logBoxes[2].AppendText("> systemctl $act nginx`n")
        $logBoxes[2].ScrollToCaret()
        # Exécuter la commande
        ssh -i $global:sshKey root@$global:VPS_IP "systemctl $act nginx" 2>&1 | Out-Null
        # Vérifier le statut final
        $statusCheck = ssh -i $global:sshKey root@$global:VPS_IP "systemctl is-active nginx" 2>&1
        if ($act -eq "stop") {
            if ($statusCheck -eq "inactive") { $logBoxes[2].AppendText("=> nginx arrêté avec succès.`n") }
            else { $logBoxes[2].AppendText("=> Attention : nginx est $statusCheck.`n") }
        } else {
            if ($statusCheck -eq "active") { $logBoxes[2].AppendText("=> nginx actif.`n") }
            else { $logBoxes[2].AppendText("=> Attention : nginx est $statusCheck.`n") }
        }
        $logBoxes[2].ScrollToCaret()
    })
    $menuNginx.Items.Add($item)
}

$separator = New-Object System.Windows.Forms.ToolStripSeparator
$menuNginx.Items.Add($separator)

$statusItem = New-Object System.Windows.Forms.ToolStripMenuItem
$statusItem.Text = "status"
$statusItem.BackColor = "#18191a"
$statusItem.ForeColor = "White"
$statusItem.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$statusItem.Padding = 0
$statusItem.Margin = 0
$statusItem.Add_Click({
    $logBoxes[2].AppendText("> systemctl status nginx (résumé)`n")
    $logBoxes[2].ScrollToCaret()
    $result = ssh -i $global:sshKey root@$global:VPS_IP "systemctl show nginx --property=Names,LoadState,ActiveState,SubState,MainPID,MemoryCurrent 2>&1"
    if ($result) {
        $clean = $result -replace '[^\x00-\x7F]', ''
        $data = @{}
        $clean -split "`n" | ForEach-Object {
            if ($_ -match '^([^=]+)=(.*)$') { $data[$matches[1]] = $matches[2] }
        }
        $name = $data['Names'] -replace '\.service',''
        $load = $data['LoadState']
        $active = $data['ActiveState']
        $sub = $data['SubState']
        $mainPid = if ($data['MainPID'] -eq 0) { "aucun" } else { $data['MainPID'] }
        $mem = if ($data['MemoryCurrent'] -gt 0) { "$([math]::Round($data['MemoryCurrent']/1MB,1)) MB" } else { "n/a" }
        $logBoxes[2].AppendText("Service : $name`n")
        $logBoxes[2].AppendText("Loaded  : $load`n")
        $logBoxes[2].AppendText("Active  : $active ($sub)`n")
        $logBoxes[2].AppendText("Main PID: $mainPid`n")
        $logBoxes[2].AppendText("Memory  : $mem`n")
    } else {
        $logBoxes[2].AppendText("Impossible de récupérer le statut`n")
    }
    $logBoxes[2].ScrollToCaret()
})
$menuNginx.Items.Add($statusItem)

$btnActionses[2].Add_Click({ $menuNginx.Show($btnActionses[2], 0, $btnActionses[2].Height) })

# ----- postgresql (systemd) - carte 3 (version ultra-simple) -----
$menuPostgresql = New-Object System.Windows.Forms.ContextMenuStrip
$menuPostgresql.BackColor = "#18191a"
$menuPostgresql.ForeColor = "White"
$menuPostgresql.ShowImageMargin = $false
$menuPostgresql.Padding = 0

$actionsPostgresql = @("start","stop","restart")
foreach ($action in $actionsPostgresql) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $action
    $item.BackColor = "#18191a"
    $item.ForeColor = "White"
    $item.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $item.Padding = 0
    $item.Margin = 0
    $item.Tag = $action
    $item.Add_Click({
        $act = $this.Tag
        $logBoxes[3].AppendText("> systemctl $act postgresql`n")
        $logBoxes[3].ScrollToCaret()
        ssh -i $global:sshKey root@$global:VPS_IP "systemctl $act postgresql" 2>&1 | Out-Null
        $logBoxes[3].AppendText("(commande envoyée, voir les logs pour le résultat)`n")
        $logBoxes[3].ScrollToCaret()
    })
    $menuPostgresql.Items.Add($item)
}

$separator = New-Object System.Windows.Forms.ToolStripSeparator
$menuPostgresql.Items.Add($separator)

$statusItem = New-Object System.Windows.Forms.ToolStripMenuItem
$statusItem.Text = "status"
$statusItem.BackColor = "#18191a"
$statusItem.ForeColor = "White"
$statusItem.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$statusItem.Padding = 0
$statusItem.Margin = 0
$statusItem.Add_Click({
    $logBoxes[3].AppendText("> systemctl status postgresql (résumé)`n")
    $logBoxes[3].ScrollToCaret()
    $result = ssh -i $global:sshKey root@$global:VPS_IP "systemctl show postgresql --property=Names,LoadState,ActiveState,SubState,MainPID,MemoryCurrent 2>&1"
    if ($result) {
        $clean = $result -replace '[^\x00-\x7F]', ''
        $data = @{}
        $clean -split "`n" | ForEach-Object {
            if ($_ -match '^([^=]+)=(.*)$') { $data[$matches[1]] = $matches[2] }
        }
        $name = $data['Names'] -replace '\.service',''
        $load = $data['LoadState']
        $active = $data['ActiveState']
        $sub = $data['SubState']
        $mainPid = if ($data['MainPID'] -eq 0) { "aucun" } else { $data['MainPID'] }
        $mem = if ($data['MemoryCurrent'] -gt 0) { "$([math]::Round($data['MemoryCurrent']/1MB,1)) MB" } else { "n/a" }
        $logBoxes[3].AppendText("Service : $name`n")
        $logBoxes[3].AppendText("Loaded  : $load`n")
        $logBoxes[3].AppendText("Active  : $active ($sub)`n")
        $logBoxes[3].AppendText("Main PID: $mainPid`n")
        $logBoxes[3].AppendText("Memory  : $mem`n")
    } else {
        $logBoxes[3].AppendText("Impossible de récupérer le statut`n")
    }
    $logBoxes[3].ScrollToCaret()
})
$menuPostgresql.Items.Add($statusItem)

$btnActionses[3].Add_Click({ $menuPostgresql.Show($btnActionses[3], 0, $btnActionses[3].Height) })

# ----- php8.3-fpm (systemd) - carte 4 -----
$menuPhp = New-Object System.Windows.Forms.ContextMenuStrip
$menuPhp.BackColor = "#18191a"
$menuPhp.ForeColor = "White"
$menuPhp.ShowImageMargin = $false
$menuPhp.Padding = 0

$actionsPhp = @("start","stop","restart")
foreach ($action in $actionsPhp) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $action
    $item.BackColor = "#18191a"
    $item.ForeColor = "White"
    $item.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $item.Padding = 0
    $item.Margin = 0
    $item.Tag = $action
    $item.Add_Click({
        $act = $this.Tag
        $logBoxes[4].AppendText("> systemctl $act php8.3-fpm`n")
        $logBoxes[4].ScrollToCaret()
        $result = ssh -i $global:sshKey root@$global:VPS_IP "systemctl $act php8.3-fpm 2>&1 ; echo EXITCODE:\$?"
        $lines = $result -split "`n"
        $exitLine = $lines | Where-Object { $_ -match '^EXITCODE:(\d+)' } | Select-Object -First 1
        $exitCode = if ($exitLine -match '(\d+)') { $matches[1] } else { -1 }
        $output = $lines | Where-Object { $_ -notmatch '^EXITCODE:' } | Where-Object { $_ -ne "" }
        if ($output) { $logBoxes[4].AppendText($output -join "`n" + "`n") }
        if ($exitCode -eq 0) {
            $statusCheck = ssh -i $global:sshKey root@$global:VPS_IP "systemctl is-active php8.3-fpm 2>&1"
            if ($act -eq "stop") {
                if ($statusCheck -eq "inactive") { $logBoxes[4].AppendText("=> php8.3-fpm arrêté avec succès.`n") }
                else { $logBoxes[4].AppendText("=> Attention : php8.3-fpm est $statusCheck.`n") }
            } else {
                if ($statusCheck -eq "active") { $logBoxes[4].AppendText("=> php8.3-fpm actif.`n") }
                else { $logBoxes[4].AppendText("=> Attention : php8.3-fpm est $statusCheck.`n") }
            }
        } else {
            $logBoxes[4].AppendText("=> La commande a échoué (code $exitCode).`n")
        }
        $logBoxes[4].ScrollToCaret()
    })
    $menuPhp.Items.Add($item)
}

$separator = New-Object System.Windows.Forms.ToolStripSeparator
$menuPhp.Items.Add($separator)

$statusItem = New-Object System.Windows.Forms.ToolStripMenuItem
$statusItem.Text = "status"
$statusItem.BackColor = "#18191a"
$statusItem.ForeColor = "White"
$statusItem.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$statusItem.Padding = 0
$statusItem.Margin = 0
$statusItem.Add_Click({
    $logBoxes[4].AppendText("> systemctl status php8.3-fpm (résumé)`n")
    $logBoxes[4].ScrollToCaret()
    $result = ssh -i $global:sshKey root@$global:VPS_IP "systemctl show php8.3-fpm --property=Names,LoadState,ActiveState,SubState,MainPID,MemoryCurrent 2>&1"
    if ($result) {
        $clean = $result -replace '[^\x00-\x7F]', ''
        $data = @{}
        $clean -split "`n" | ForEach-Object {
            if ($_ -match '^([^=]+)=(.*)$') { $data[$matches[1]] = $matches[2] }
        }
        $name = $data['Names'] -replace '\.service',''
        $load = $data['LoadState']
        $active = $data['ActiveState']
        $sub = $data['SubState']
        $mainPid = if ($data['MainPID'] -eq 0) { "aucun" } else { $data['MainPID'] }
        $mem = if ($data['MemoryCurrent'] -gt 0) { "$([math]::Round($data['MemoryCurrent']/1MB,1)) MB" } else { "n/a" }
        $logBoxes[4].AppendText("Service : $name`n")
        $logBoxes[4].AppendText("Loaded  : $load`n")
        $logBoxes[4].AppendText("Active  : $active ($sub)`n")
        $logBoxes[4].AppendText("Main PID: $mainPid`n")
        $logBoxes[4].AppendText("Memory  : $mem`n")
    } else {
        $logBoxes[4].AppendText("Impossible de récupérer le statut`n")
    }
    $logBoxes[4].ScrollToCaret()
})
$menuPhp.Items.Add($statusItem)

$btnActionses[4].Add_Click({ $menuPhp.Show($btnActionses[4], 0, $btnActionses[4].Height) })

# ----- fail2ban (systemd) - carte 5 (version simplifiée) -----
$menuFail2ban = New-Object System.Windows.Forms.ContextMenuStrip
$menuFail2ban.BackColor = "#18191a"
$menuFail2ban.ForeColor = "White"
$menuFail2ban.ShowImageMargin = $false
$menuFail2ban.Padding = 0

$actionsFail2ban = @("start","stop","restart","reload")
foreach ($action in $actionsFail2ban) {
    $item = New-Object System.Windows.Forms.ToolStripMenuItem
    $item.Text = $action
    $item.BackColor = "#18191a"
    $item.ForeColor = "White"
    $item.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $item.Padding = 0
    $item.Margin = 0
    $item.Tag = $action
    $item.Add_Click({
        $act = $this.Tag
        $logBoxes[5].AppendText("> systemctl $act fail2ban`n")
        $logBoxes[5].ScrollToCaret()
        ssh -i $global:sshKey root@$global:VPS_IP "systemctl $act fail2ban" 2>&1 | Out-Null
        $logBoxes[5].AppendText("(commande envoyée, voir les logs pour le résultat)`n")
        $logBoxes[5].ScrollToCaret()
    })
    $menuFail2ban.Items.Add($item)
}

$separator = New-Object System.Windows.Forms.ToolStripSeparator
$menuFail2ban.Items.Add($separator)

$statusItem = New-Object System.Windows.Forms.ToolStripMenuItem
$statusItem.Text = "status"
$statusItem.BackColor = "#18191a"
$statusItem.ForeColor = "White"
$statusItem.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$statusItem.Padding = 0
$statusItem.Margin = 0
$statusItem.Add_Click({
    $logBoxes[5].AppendText("> systemctl status fail2ban (résumé)`n")
    $logBoxes[5].ScrollToCaret()
    $result = ssh -i $global:sshKey root@$global:VPS_IP "systemctl show fail2ban --property=Names,LoadState,ActiveState,SubState,MainPID,MemoryCurrent 2>&1"
    if ($result) {
        $clean = $result -replace '[^\x00-\x7F]', ''
        $data = @{}
        $clean -split "`n" | ForEach-Object {
            if ($_ -match '^([^=]+)=(.*)$') { $data[$matches[1]] = $matches[2] }
        }
        $name = $data['Names'] -replace '\.service',''
        $load = $data['LoadState']
        $active = $data['ActiveState']
        $sub = $data['SubState']
        $mainPid = if ($data['MainPID'] -eq 0) { "aucun" } else { $data['MainPID'] }
        $mem = if ($data['MemoryCurrent'] -gt 0) { "$([math]::Round($data['MemoryCurrent']/1MB,1)) MB" } else { "n/a" }
        $logBoxes[5].AppendText("Service : $name`n")
        $logBoxes[5].AppendText("Loaded  : $load`n")
        $logBoxes[5].AppendText("Active  : $active ($sub)`n")
        $logBoxes[5].AppendText("Main PID: $mainPid`n")
        $logBoxes[5].AppendText("Memory  : $mem`n")
    } else {
        $logBoxes[5].AppendText("Impossible de récupérer le statut`n")
    }
    $logBoxes[5].ScrollToCaret()
})
$menuFail2ban.Items.Add($statusItem)

$btnActionses[5].Add_Click({ $menuFail2ban.Show($btnActionses[5], 0, $btnActionses[5].Height) })
# ==============================================
# LIER LES BOUTONS ZOOM
# ==============================================
for ($i = 0; $i -lt 6; $i++) {
    $btnZoom = $cards[$i].Tag.BtnZoom
    $btnClose = $cards[$i].Tag.BtnClose
    $btnZoom.Add_Click({
        $idx = $this.Tag
        Toggle-Zoom $cards[$idx]
    })
    $btnClose.Add_Click({
        $idx = $this.Tag
        Toggle-Zoom $cards[$idx]
    })
}

# ==============================================
# BOUTONS DU PANEL GAUCHE
# ==============================================
$btnMonitoring.Add_Click({
    $cmdBox.AppendText("=== MONITORING COMPLET ===`n")
Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "/root/scripts/panel-api.sh full 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null})

$btnStatus.Add_Click({
    $cmdBox.AppendText("=== STATUS RAPIDE ===`n")
    Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "/root/scripts/panel-api.sh status 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null})

$btnLogsSimple.Add_Click({
    $cmdBox.AppendText("=== DERNIERS LOGS ===`n")
    Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "/root/scripts/panel-api.sh logs 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null})


$btnLogsRealtime.Add_Click({
    $cmdBox.AppendText("[LOGS] Streaming automatique actif`n")
})

$btnReboot.Add_Click({
    $cmdBox.AppendText("[REBOOT] Redémarrage dans 1 minute...`n")
     Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "/root/scripts/panel-api.sh reboot 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null})

$btnForceReboot.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show(
        "⚠️ ATTENTION : Le redémarrage forcé (reboot -f) arrête immédiatement le système sans fermer proprement les services.`n`nCela peut entraîner une perte de données ou une corruption des fichiers.`n`nÊtes-vous sûr de vouloir continuer ?",
        "Confirmation - Force reboot",
        "YesNo",
        "Warning"
    )
    if ($result -eq "Yes") {
        $cmdBox.AppendText("[FORCE REBOOT] Redémarrage immédiat...`n")
        Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "/root/scripts/panel-api.sh reboot-force 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null
    } else {
        $cmdBox.AppendText("[FORCE REBOOT] Annulé par l'utilisateur.`n")
    }
})
$btnSecurite.Add_Click({
    $cmdBox.AppendText("=== FAIL2BAN STATUS ===`n")
    Start-Job -ScriptBlock { param($ip, $key) ssh -i "$key" root@$ip "/root/scripts/panel-api.sh security 2>&1" } -ArgumentList $global:VPS_IP, $global:sshKey | Out-Null})

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
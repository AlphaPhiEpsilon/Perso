# ==============================================
# dashboard_stream.ps1
# Streaming des logs, mise à jour des LEDs et du compteur
# ==============================================

# Variables de streaming
$script:streamJob = $null
$script:streamActive = $false
$script:streamTimer = $null
$script:autoMode = $true
$script:isClosing = $false

# Couleurs pour les logs
$global:logColors = @{
    "MEETGAY" = "#86efac"
    "SSHD" = "#86efac"
    "NGINX" = "#86efac"
    "POSTGRESQL" = "#86efac"
    "PHP" = "#86efac"
    "FAIL2BAN" = "#86efac"
    "ERROR" = "#f87171"
    "WARN" = "#fbbf24"
}

# ==============================================
# FONCTIONS D'AFFICHAGE COLORÉ
# ==============================================
function Add-ColoredLine {
    param($box, $line)
    if ($script:isClosing) { return }
    # Nettoyage des caractères non ASCII
    $cleanLine = $line -replace '[^\x00-\x7F]', ''
    $box.SuspendLayout()
    $box.SelectionStart = $box.TextLength
    $box.SelectionLength = 0
    
    $color = "#86efac"
    if ($cleanLine -match "(?i)(error|fail|fatal|exception|refused)") { $color = $global:logColors["ERROR"] }
    elseif ($cleanLine -match "(?i)(warn|warning)") { $color = $global:logColors["WARN"] }
    
    $box.SelectionColor = $color
    $box.AppendText($cleanLine + "`n")
    $box.SelectionStart = $box.Text.Length
    $box.ScrollToCaret()
    $box.ResumeLayout()
}

# ==============================================
# TRAITEMENT DES LIGNES DE LOG
# ==============================================
function Process-LogLine {
    param($line)
    if ($null -eq $line) { return }
    $text = "$line"
    if ([string]::IsNullOrWhiteSpace($text) -or $script:isClosing) { return }
    
    # Afficher dans les logs système
    Add-ColoredLine $sysLogBox $text
    
    # Distribution vers les cartes selon le préfixe
    if ($text -match "^\[MEETGAY\]") { Add-ColoredLine $logBoxes[0] $text }
    elseif ($text -match "^\[SSHD\]") { Add-ColoredLine $logBoxes[1] $text }
    elseif ($text -match "^\[NGINX") { Add-ColoredLine $logBoxes[2] $text }
    elseif ($text -match "^\[POSTGRESQL\]") { Add-ColoredLine $logBoxes[3] $text }
    elseif ($text -match "^\[PHP\]") { Add-ColoredLine $logBoxes[4] $text }
    elseif ($text -match "^\[FAIL2BAN\]") { Add-ColoredLine $logBoxes[5] $text }
    elseif ($text -match "^\[STATUS\]") {
        # Extraction des statuts pour les LEDs
        $meetgay = ""; $meetgay_uptime = ""; $nginx = ""; $pg = ""; $php = ""; $sshd = ""; $fail2ban = ""
        
        if ($text -match "meetgay:(\S+)") { $meetgay = $matches[1] }
        if ($text -match "uptime:([^\s]+)") { 
            if ($meetgay_uptime -eq "") { $meetgay_uptime = $matches[1] }
        }
        if ($text -match "nginx:(\S+)") { $nginx = $matches[1] }
        if ($text -match "postgresql:(\S+)") { $pg = $matches[1] }
        if ($text -match "php:(\S+)") { $php = $matches[1] }
        if ($text -match "sshd:(\S+)") { $sshd = $matches[1] }
        if ($text -match "fail2ban:(\S+)") { $fail2ban = $matches[1] }
        
        $form.Invoke([Action]{
            if ($meetgay -ne "") {
                $ledLabels[0].Text = if ($meetgay -eq "online") { "● EN LIGNE" } else { "○ HORS LIGNE" }
                $ledLabels[0].ForeColor = if ($meetgay -eq "online") { "#2ecc71" } else { "#e74c3c" }
                if ($meetgay_uptime -ne "") { $uptimeLabels[0].Text = $meetgay_uptime }
            }
            if ($nginx -ne "") {
                $ledLabels[2].Text = if ($nginx -eq "active") { "● EN LIGNE" } else { "○ HORS LIGNE" }
                $ledLabels[2].ForeColor = if ($nginx -eq "active") { "#2ecc71" } else { "#e74c3c" }
                $uptimeLabels[2].Text = $nginx
            }
            if ($pg -ne "") {
                $ledLabels[3].Text = if ($pg -eq "active") { "● EN LIGNE" } else { "○ HORS LIGNE" }
                $ledLabels[3].ForeColor = if ($pg -eq "active") { "#2ecc71" } else { "#e74c3c" }
                $uptimeLabels[3].Text = $pg
            }
            if ($php -ne "") {
                $ledLabels[4].Text = if ($php -eq "active") { "● EN LIGNE" } else { "○ HORS LIGNE" }
                $ledLabels[4].ForeColor = if ($php -eq "active") { "#2ecc71" } else { "#e74c3c" }
                $uptimeLabels[4].Text = $php
            }
            if ($sshd -ne "") {
                $ledLabels[1].Text = if ($sshd -eq "active") { "● EN LIGNE" } else { "○ HORS LIGNE" }
                $ledLabels[1].ForeColor = if ($sshd -eq "active") { "#2ecc71" } else { "#e74c3c" }
                $uptimeLabels[1].Text = $sshd
            }
            if ($fail2ban -ne "") {
                $ledLabels[5].Text = if ($fail2ban -eq "active") { "● EN LIGNE" } else { "○ HORS LIGNE" }
                $ledLabels[5].ForeColor = if ($fail2ban -eq "active") { "#2ecc71" } else { "#e74c3c" }
                $uptimeLabels[5].Text = $fail2ban
            }
        })
    }
    elseif ($text -match "^\[PROCESS_COUNT\]\s+(\d+)") {
        $count = $matches[1]
        $form.Invoke([Action]{
            $lblProcessCount.Text = if ($count -eq "0") { "✅ 0 processus" } else { "⚠️ $count processus" }
            $lblProcessCount.ForeColor = if ($count -eq "0") { "#2ecc71" } else { "#f87171" }
        })
    }
}

# ==============================================
# DÉMARRAGE / ARRÊT DU STREAM
# ==============================================
function Start-GlobalStream {
    ssh root@$VPS_IP "pkill -f 'stream-logs.sh' 2>/dev/null" | Out-Null
    if ($script:streamActive -or $script:isClosing) { return }
    
    $logBoxes[0].Clear(); $logBoxes[0].AppendText("===== LOGS MEETGAY =====`n[Connexion...]`n")
    $logBoxes[1].Clear(); $logBoxes[1].AppendText("===== LOGS SSHD =====`n[Connexion...]`n")
    $logBoxes[2].Clear(); $logBoxes[2].AppendText("===== LOGS NGINX =====`n[Connexion...]`n")
    $logBoxes[3].Clear(); $logBoxes[3].AppendText("===== LOGS POSTGRESQL =====`n[Connexion...]`n")
    $logBoxes[4].Clear(); $logBoxes[4].AppendText("===== LOGS PHP =====`n[Connexion...]`n")
    $logBoxes[5].Clear(); $logBoxes[5].AppendText("===== LOGS FAIL2BAN =====`n[Connexion...]`n")
    $sysLogBox.Clear(); $sysLogBox.Text = "[Connexion...]`n"
    
    $script:streamActive = $true
    $script:streamJob = Start-Job -ScriptBlock {
        param($ip)
        ssh -o ConnectTimeout=10 root@$ip "/root/stream-logs.sh" 2>&1
    } -ArgumentList $VPS_IP
    
    $script:streamTimer = New-Object System.Windows.Forms.Timer
    $script:streamTimer.Interval = 300
    $script:streamTimer.Add_Tick({
        if ($script:streamJob -ne $null -and $script:streamActive -and -not $script:isClosing) {
            try {
                if ($script:streamJob.HasMoreData) {
                    $lines = Receive-Job -Job $script:streamJob -ErrorAction SilentlyContinue
                    if ($lines) {
                        $linesArray = @($lines)
                        foreach ($l in $linesArray) { Process-LogLine $l }
                    }
                }
                if ($script:streamJob.State -ne 'Running') {
                    $remaining = Receive-Job -Job $script:streamJob -ErrorAction SilentlyContinue
                    if ($remaining) { Process-LogLine $remaining }
                    Remove-Job $script:streamJob -Force -ErrorAction SilentlyContinue
                    $script:streamJob = $null
                    $script:streamActive = $false
                    $script:streamTimer.Stop()
                    foreach ($box in $logBoxes) { Add-ColoredLine $box "[STREAM] Connexion perdue - cliquez sur ⟳ pour reconnecter" }
                }
            } catch {
                # Ignorer l'erreur
            }
        }
    })
    $script:streamTimer.Start()
}

function Stop-GlobalStream {
    if (-not $script:streamActive) { return }
    $script:streamActive = $false
    if ($script:streamTimer) { $script:streamTimer.Stop(); $script:streamTimer = $null }
    if ($script:streamJob) { 
        Stop-Job $script:streamJob -ErrorAction SilentlyContinue
        Receive-Job $script:streamJob -ErrorAction SilentlyContinue
        Remove-Job $script:streamJob -Force -ErrorAction SilentlyContinue
        $script:streamJob = $null
    }
   
}

function Kill-AllSSH {
   
    Stop-GlobalStream
    
}
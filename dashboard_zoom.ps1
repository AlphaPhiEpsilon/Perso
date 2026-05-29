# ==============================================
# dashboard_zoom.ps1
# Fonctions de zoom (agrandissement du texte et des cartes)
# ==============================================

# Variables globales de zoom
$global:zoomActive = $false
$global:zoomedCard = $null
$global:originalCardSize = $null
$global:originalCardLocation = $null
$global:originalLogFont = $null

function Toggle-Zoom {
    param($currentCard)

    $data = $currentCard.Tag
    $logBox = $data.LogBox
    $btnRefresh = $data.BtnRefresh
    $btnZoom = $data.BtnZoom
    $btnClear = $data.BtnClear
    $btnClose = $data.BtnClose

    if ($global:zoomActive -and $global:zoomedCard -eq $currentCard) {
        # --- DÉZOOM : restauration ---
        $currentCard.Size = $global:originalCardSize
        $currentCard.Location = $global:originalCardLocation
        $logBox.Font = $global:originalLogFont

        # Restaurer les positions normales (valeurs fixes)
        $btnRefresh.Location = New-Object System.Drawing.Point(215, 8)
        $btnZoom.Location = New-Object System.Drawing.Point(255, 8)
        $btnClear.Location = New-Object System.Drawing.Point(295, 8)

        foreach ($c in $cards) { $c.Visible = $true }
        $btnClose.Visible = $false

        $global:zoomActive = $false
        $global:zoomedCard = $null
    }
    elseif (-not $global:zoomActive) {
        # --- ZOOM : agrandissement ---
        $global:originalCardSize = $currentCard.Size
        $global:originalCardLocation = $currentCard.Location
        $global:originalLogFont = $logBox.Font

        foreach ($c in $cards) {
            if ($c -ne $currentCard) { $c.Visible = $false }
        }

        $currentCard.Size = $gridLogs.Size
        $currentCard.Location = New-Object System.Drawing.Point(0, 0)
        $currentCard.BringToFront()
        $logBox.Font = New-Object System.Drawing.Font($global:originalLogFont.FontFamily, 14)

        # Positions en zoom (valeurs fixes, basées sur largeur max 1060)
        # Ajuste ces valeurs si besoin
        $btnRefresh.Location = New-Object System.Drawing.Point(940, 8)   # 1060 - 120
        $btnZoom.Location = New-Object System.Drawing.Point(980, 8)       # 1060 - 80
        $btnClear.Location = New-Object System.Drawing.Point(1020, 8)     # 1060 - 40

        $btnClose.Visible = $true

        $global:zoomActive = $true
        $global:zoomedCard = $currentCard
    }
}
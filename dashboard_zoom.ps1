# ==============================================
# dashboard_zoom.ps1
# Fonctions de zoom
# ==============================================

# Variables globales
$global:zoomActive = $false
$global:zoomedCard = $null
$global:originalCardSize = $null
$global:originalCardLocation = $null
$global:originalLogFont = $null

function Toggle-Zoom {
    param($currentCard)
    
    Write-Host "Toggle-Zoom appelé pour carte : $($currentCard.Text)" -ForegroundColor Yellow
    
    $data = $currentCard.Tag
    $logBox = $data.LogBox
    $btnRefresh = $data.BtnRefresh
    $btnZoom = $data.BtnZoom
    $btnClear = $data.BtnClear
    $btnClose = $data.BtnClose
    
    Write-Host "zoomActive = $($global:zoomActive)" -ForegroundColor Cyan
    
    if ($global:zoomActive -and $global:zoomedCard -eq $currentCard) {
        Write-Host "DÉZOOM" -ForegroundColor Green
        
        # Restaurer la taille et la position
        $currentCard.Size = $global:originalCardSize
        $currentCard.Location = $global:originalCardLocation
        $logBox.Font = $global:originalLogFont
        
        # Restaurer les positions des boutons
        $btnRefresh.Location = New-Object System.Drawing.Point(215, 15)
        $btnZoom.Location = New-Object System.Drawing.Point(255, 15)
        $btnClear.Location = New-Object System.Drawing.Point(295, 15)
        $btnClose.Location = New-Object System.Drawing.Point(10, 15)
        
        # Rendre toutes les cartes visibles
        if ($script:cards) {
            foreach ($c in $script:cards) { 
                if ($c -and $c -ne $currentCard) { $c.Visible = $true }
            }
        }
        $btnClose.Visible = $false
        
        $global:zoomActive = $false
        $global:zoomedCard = $null
    }
    elseif (-not $global:zoomActive) {
        Write-Host "ZOOM" -ForegroundColor Green
        
        # Sauvegarder l'état original
        $global:originalCardSize = $currentCard.Size
        $global:originalCardLocation = $currentCard.Location
        $global:originalLogFont = $logBox.Font
        
        # Cacher les autres cartes
        if ($script:cards) {
            foreach ($c in $script:cards) {
                if ($c -and $c -ne $currentCard) { 
                    $c.Visible = $false 
                }
            }
        }
        
        # Agrandir la carte
        if ($script:gridLogs) {
            $currentCard.Size = $script:gridLogs.Size
        } else {
            $currentCard.Size = New-Object System.Drawing.Size(1060, 660)
        }
        $currentCard.Location = New-Object System.Drawing.Point(0, 0)
        $currentCard.BringToFront()
        $logBox.Font = New-Object System.Drawing.Font("Consolas", 14, [System.Drawing.FontStyle]::Regular)
        
        # Repositionner les boutons en mode zoom
        $btnRefresh.Location = New-Object System.Drawing.Point(920, 15)
        $btnZoom.Location = New-Object System.Drawing.Point(960, 15)
        $btnClear.Location = New-Object System.Drawing.Point(1000, 15)
        $btnClose.Location = New-Object System.Drawing.Point(10, 15)
        
        $btnClose.Visible = $true
        
        $global:zoomActive = $true
        $global:zoomedCard = $currentCard
    }
}

# ⚠️ FONCTION CRUCIALE : Attache les événements aux boutons
function Initialize-ZoomEvents {
    Write-Host "Initialisation des événements de zoom..." -ForegroundColor Magenta
    
    if (-not $script:btnZooms) {
        Write-Host "ERREUR: script:btnZooms n'existe pas!" -ForegroundColor Red
        return
    }
    
    Write-Host "Nombre de boutons zoom trouvés : $($script:btnZooms.Count)" -ForegroundColor Cyan
    
    for ($i = 0; $i -lt $script:btnZooms.Count; $i++) {
        $index = $i
        $btn = $script:btnZooms[$index]
        
        Write-Host "Attachement événement pour zoom bouton $index" -ForegroundColor Gray
        
        $btn.Add_Click({
            Write-Host "CLIC ZOOM sur carte $index" -ForegroundColor Yellow
            if ($script:cards -and $script:cards[$index]) {
                Toggle-Zoom $script:cards[$index]
            } else {
                Write-Host "ERREUR: Carte $index introuvable" -ForegroundColor Red
            }
        })
    }
    
    # Événements pour les boutons fermeture
    if ($script:btnCloses) {
        for ($i = 0; $i -lt $script:btnCloses.Count; $i++) {
            $index = $i
            $btn = $script:btnCloses[$index]
            
            $btn.Add_Click({
                Write-Host "CLIC FERMETURE sur carte $index" -ForegroundColor Yellow
                if ($global:zoomActive -and $global:zoomedCard -eq $script:cards[$index]) {
                    Toggle-Zoom $script:cards[$index]
                }
            })
        }
    }
}
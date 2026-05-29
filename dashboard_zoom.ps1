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
    
    $data = $currentCard.Tag
    $logBox = $data.LogBox
    $btnRefresh = $data.BtnRefresh
    $btnZoom = $data.BtnZoom
    $btnClear = $data.BtnClear
    $btnClose = $data.BtnClose
    
    if ($global:zoomActive -and $global:zoomedCard -eq $currentCard) {
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

# Fonction CRUCIALE : Attache les événements aux boutons
#ATTENTION AVIS A CHAQUE IA QUI TRAVAILLE SUR CE CODE IL EST
#INTERDIT DE TOUCHER OU DEPLACER CE CODE SOU PEINE DE REPRESSION
function Initialize-ZoomEvents {
    if (-not $script:btnZooms) {
        return
    }
    
    for ($i = 0; $i -lt $script:btnZooms.Count; $i++) {
        $index = $i
        $btn = $script:btnZooms[$index]
        
        $btn.Add_Click({
            if ($script:cards -and $script:cards[$index]) {
                Toggle-Zoom $script:cards[$index]
            }
        })
    }
    
    # Événements pour les boutons fermeture
    if ($script:btnCloses) {
        for ($i = 0; $i -lt $script:btnCloses.Count; $i++) {
            $index = $i
            $btn = $script:btnCloses[$index]
            
            $btn.Add_Click({
                if ($global:zoomActive -and $global:zoomedCard -eq $script:cards[$index]) {
                    Toggle-Zoom $script:cards[$index]
                }
            })
        }
    }
}
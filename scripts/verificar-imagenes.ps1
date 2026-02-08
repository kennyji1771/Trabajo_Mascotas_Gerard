# Script: verificar-imagenes.ps1
Write-Host "=== VERIFICADOR DE IMÁGENES ===" -ForegroundColor Cyan
Write-Host "Por: Gerard Sieveres - UNEXCA" -ForegroundColor Yellow
Write-Host ""

# Verificar estructura básica
Write-Host "1. 📁 ESTRUCTURA ACTUAL:" -ForegroundColor Green
Write-Host "   Ubicación: $(Get-Location)" -ForegroundColor Gray

if (Test-Path "html") {
    Write-Host "   ✅ Carpeta 'html' encontrada" -ForegroundColor Green
    if (Test-Path "html\index.html") {
        Write-Host "   ✅ Archivo 'html\index.html' encontrado" -ForegroundColor Green
    } else {
        Write-Host "   ❌ NO se encuentra 'html\index.html'" -ForegroundColor Red
    }
} else {
    Write-Host "   ❌ NO se encuentra carpeta 'html'" -ForegroundColor Red
}

if (Test-Path "imagenes") {
    Write-Host "   ✅ Carpeta 'imagenes' encontrada" -ForegroundColor Green
    $imagenes = Get-ChildItem "imagenes\*" -Include *.png, *.jpg, *.jpeg, *.gif
    Write-Host "   📸 Archivos en imagenes/: $($imagenes.Count)" -ForegroundColor Gray
    $imagenes | ForEach-Object { 
        Write-Host "     - $($_.Name) ($([math]::Round($_.Length/1KB,2)) KB)" -ForegroundColor Gray 
    }
} else {
    Write-Host "   ❌ NO se encuentra carpeta 'imagenes'" -ForegroundColor Red
}

# Verificar rutas en el HTML
Write-Host "`n2. 🔍 ANALIZANDO HTML:" -ForegroundColor Green

if (Test-Path "html\index.html") {
    $htmlContent = Get-Content "html\index.html" -Raw
    
    # Buscar todas las imágenes
    $pattern = 'src=["'']([^"'']+\.(?:png|jpg|jpeg|gif))["'']'
    $matches = [regex]::Matches($htmlContent, $pattern)
    
    Write-Host "   Se encontraron $($matches.Count) referencias a imágenes" -ForegroundColor Gray
    
    $correctas = 0
    $incorrectas = 0
    
    foreach ($match in $matches) {
        $rutaHTML = $match.Groups[1].Value
        $rutaCompleta = ""
        
        # Determinar ruta física
        if ($rutaHTML -like "../imagenes/*") {
            $archivo = $rutaHTML -replace '\.\./imagenes/', ''
            $rutaCompleta = "imagenes\$archivo"
        } elseif ($rutaHTML -like "imagenes/*") {
            $archivo = $rutaHTML -replace 'imagenes/', ''
            $rutaCompleta = "imagenes\$archivo"
        } else {
            $rutaCompleta = "html\$rutaHTML"
        }
        
        $rutaCompleta = $rutaCompleta -replace '/', '\'
        
        if (Test-Path $rutaCompleta) {
            Write-Host "   ✅ $rutaHTML -> EXISTE" -ForegroundColor Green
            $correctas++
        } else {
            Write-Host "   ❌ $rutaHTML -> NO EXISTE" -ForegroundColor Red
            $incorrectas++
        }
    }
    
    Write-Host "`n3. 📊 RESULTADO:" -ForegroundColor Cyan
    Write-Host "   Rutas correctas: $correctas" -ForegroundColor $(if ($correctas -gt 0) { "Green" } else { "Red" })
    Write-Host "   Rutas incorrectas: $incorrectas" -ForegroundColor $(if ($incorrectas -eq 0) { "Green" } else { "Red" })
    
    if ($incorrectas -gt 0) {
        Write-Host "`n💡 RECOMENDACIÓN: Usa '../imagenes/' en lugar de 'imagenes/'" -ForegroundColor Yellow
    }
} else {
    Write-Host "   No se puede analizar: html\index.html no existe" -ForegroundColor Red
}

Write-Host "`n=== FIN DEL ANÁLISIS ===" -ForegroundColor Cyan

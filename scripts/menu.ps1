# Script: menu.ps1 - Menú interactivo (VERSIÓN CORREGIDA)
function Show-Menu {
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "   GESTOR DE PROYECTO HTML" -ForegroundColor Yellow
    Write-Host "   Base de Datos Mascotas - TP4" -ForegroundColor White
    Write-Host "   Estudiante: Gerard Sieveres" -ForegroundColor Gray
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    Write-Host "1. 📁 Ver estructura de carpetas" -ForegroundColor Green
    Write-Host "2. 🔍 Verificar imágenes en HTML" -ForegroundColor Yellow
    Write-Host "3. 🛠️  Corregir rutas de imágenes" -ForegroundColor Red
    Write-Host "4. 📷 Listar imágenes disponibles" -ForegroundColor Magenta
    Write-Host "5. 🌐 Abrir proyecto en navegador" -ForegroundColor Blue
    Write-Host "6. 📊 Generar reporte del proyecto" -ForegroundColor Cyan
    Write-Host "7. 🚪 Salir" -ForegroundColor DarkGray
    
    Write-Host "`n========================================" -ForegroundColor Cyan
}

do {
    Show-Menu
    $opcion = Read-Host "`nSelecciona una opción (1-7)"
    
    switch ($opcion) {
        "1" {
            Clear-Host
            Write-Host "📁 ESTRUCTURA DEL PROYECTO" -ForegroundColor Green
            Write-Host "=========================`n" -ForegroundColor Green
            
            Write-Host "📍 Ubicación actual:" -ForegroundColor Yellow
            Write-Host "   $(Get-Location)`n" -ForegroundColor Gray
            
            Write-Host "📦 Contenido de la carpeta raíz:" -ForegroundColor Yellow
            Get-ChildItem | Format-Table Name, @{n="Tipo";e={if($_.PSIsContainer){"📁 Carpeta"}else{"📄 Archivo"}}}, @{n="Tamaño";e={if($_.PSIsContainer){"-"}"{0:N2} KB" -f ($_.Length/1KB)}} -AutoSize
            
            Write-Host "`n📁 Contenido de 'html':" -ForegroundColor Yellow
            if (Test-Path "html") {
                Get-ChildItem "html" | Format-Table Name, @{n="Tamaño (KB)";e={"{0:N2}" -f ($_.Length/1KB)}}, LastWriteTime -AutoSize
            } else {
                Write-Host "   ❌ La carpeta 'html' no existe" -ForegroundColor Red
            }
            
            Write-Host "`n📷 Contenido de 'imagenes':" -ForegroundColor Yellow
            if (Test-Path "imagenes") {
                Get-ChildItem "imagenes" | Format-Table Name, @{n="Tamaño (KB)";e={"{0:N2}" -f ($_.Length/1KB)}}, LastWriteTime -AutoSize
            } else {
                Write-Host "   ❌ La carpeta 'imagenes' no existe" -ForegroundColor Red
            }
            
            Pause
        }
        "2" {
            Clear-Host
            Write-Host "🔍 VERIFICANDO IMÁGENES EN HTML..." -ForegroundColor Yellow
            Write-Host ""
            
            if (Test-Path "verificar-imagenes.ps1") {
                & .\verificar-imagenes.ps1
            } else {
                Write-Host "❌ El script 'verificar-imagenes.ps1' no existe" -ForegroundColor Red
            }
            
            Pause
        }
        "3" {
            Clear-Host
            Write-Host "🛠️  CORRIGIENDO RUTAS DE IMÁGENES..." -ForegroundColor Red
            Write-Host ""
            
            if (Test-Path "corregir-rutas.ps1") {
                & .\corregir-rutas.ps1
            } else {
                Write-Host "❌ El script 'corregir-rutas.ps1' no existe" -ForegroundColor Red
            }
            
            Pause
        }
        "4" {
            Clear-Host
            Write-Host "📷 IMÁGENES DISPONIBLES" -ForegroundColor Magenta
            Write-Host "=====================`n" -ForegroundColor Magenta
            
            if (Test-Path "imagenes") {
                $imagenes = Get-ChildItem "imagenes\*" -Include *.png, *.jpg, *.jpeg, *.gif
                
                if ($imagenes.Count -eq 0) {
                    Write-Host "   ℹ️ No se encontraron imágenes en 'imagenes/'" -ForegroundColor Blue
                } else {
                    Write-Host "   Total: $($imagenes.Count) imágenes encontradas`n" -ForegroundColor Green
                    
                    $imagenes | ForEach-Object {
                        Write-Host "   📸 $($_.Name)" -ForegroundColor White
                        # CORREGIDO: Formatear primero, luego mostrar
                        $tamanoFormateado = "{0:N2} KB" -f ($_.Length/1KB)
                        Write-Host "      Tamaño: $tamanoFormateado" -ForegroundColor Gray
                        Write-Host "      Modificado: $($_.LastWriteTime.ToString('dd/MM/yyyy HH:mm'))" -ForegroundColor Gray
                        Write-Host ""
                    }
                }
            } else {
                Write-Host "   ❌ La carpeta 'imagenes' no existe" -ForegroundColor Red
            }
            
            Pause
        }
        "5" {
            Clear-Host
            Write-Host "🌐 ABRIENDO PROYECTO EN NAVEGADOR..." -ForegroundColor Blue
            
            if (Test-Path "html\index.html") {
                Write-Host "   Abriendo: html\index.html" -ForegroundColor Green
                Start-Process "html\index.html"
            } else {
                Write-Host "   ❌ No se encuentra html\index.html" -ForegroundColor Red
            }
            
            Write-Host "`n   ℹ️ El navegador se abrirá automáticamente..." -ForegroundColor Gray
            Start-Sleep -Seconds 2
        }
        "6" {
            Clear-Host
            Write-Host "📊 GENERANDO REPORTE DEL PROYECTO..." -ForegroundColor Cyan
            
            $reporte = @()
            $fecha = Get-Date -Format "dd/MM/yyyy HH:mm"
            
            $reporte += "=" * 50
            $reporte += "REPORTE DEL PROYECTO - Trabajo Práctico 4"
            $reporte += "Base de Datos Mascotas"
            $reporte += "Estudiante: Gerard Sieveres"
            $reporte += "Fecha: $fecha"
            $reporte += "=" * 50
            $reporte += ""
            
            # Información de carpetas
            $reporte += "📁 ESTRUCTURA DE CARPETAS:"
            $reporte += "Ubicación: $(Get-Location)"
            
            if (Test-Path "html") {
                $htmlFiles = Get-ChildItem "html" -File
                $reporte += "Carpeta 'html': $($htmlFiles.Count) archivos"
            } else {
                $reporte += "Carpeta 'html': NO EXISTE"
            }
            
            if (Test-Path "imagenes") {
                $imagenes = Get-ChildItem "imagenes" -File -Include *.png, *.jpg, *.jpeg, *.gif
                $reporte += "Carpeta 'imagenes': $($imagenes.Count) imágenes"
            } else {
                $reporte += "Carpeta 'imagenes': NO EXISTE"
            }
            
            $reporte += ""
            
            # Guardar reporte
            $nombreReporte = "reporte_proyecto_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
            $reporte | Out-File $nombreReporte
            
            Write-Host "✅ Reporte generado: $nombreReporte" -ForegroundColor Green
            Write-Host "`n📋 Contenido del reporte:" -ForegroundColor Yellow
            Get-Content $nombreReporte
            
            Pause
        }
        "7" {
            Write-Host "`n👋 ¡Hasta luego!" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            exit
        }
        default {
            Write-Host "`n❌ Opción no válida. Intenta de nuevo." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($true)

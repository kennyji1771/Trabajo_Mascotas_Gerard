# Script: corregir-rutas.ps1
Write-Host "🔧 CORRECTOR DE RUTAS DE IMÁGENES" -ForegroundColor Cyan
Write-Host ""

$htmlPath = "html\index.html"
if (-not (Test-Path $htmlPath)) {
    Write-Host "❌ ERROR: No se encuentra $htmlPath" -ForegroundColor Red
    exit 1
}

# Leer contenido
$contenido = Get-Content $htmlPath -Raw

# Contar cuántas rutas 'imagenes/' hay
$antes = [regex]::Matches($contenido, 'src=["'']imagenes/').Count

if ($antes -eq 0) {
    Write-Host "ℹ️ No se encontraron rutas 'imagenes/' para corregir." -ForegroundColor Blue
    Write-Host "   Las rutas ya podrían estar correctas (usando '../imagenes/')" -ForegroundColor Gray
    exit 0
}

Write-Host "Se encontraron $antes rutas 'imagenes/' que necesitan corrección" -ForegroundColor Yellow

# Crear backup
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupPath = "$htmlPath.backup_$timestamp"
Copy-Item $htmlPath $backupPath -Force
Write-Host "📁 Backup creado: $backupPath" -ForegroundColor Gray

# Reemplazar todas las ocurrencias
$contenidoCorregido = $contenido -replace 'src=["'']imagenes/', 'src="../imagenes/'

# Contar después
$despues = [regex]::Matches($contenidoCorregido, 'src=["'']\.\./imagenes/').Count

# Guardar cambios
Set-Content -Path $htmlPath -Value $contenidoCorregido -Encoding UTF8

Write-Host "✅ $antes rutas corregidas a '../imagenes/'" -ForegroundColor Green
Write-Host "📄 Archivo actualizado: $htmlPath" -ForegroundColor Green

# Mostrar ejemplo de cambio
Write-Host "`n📝 EJEMPLO DE CAMBIO:" -ForegroundColor Cyan
Write-Host "   ANTES: <img src='imagenes/Portada.png'>" -ForegroundColor Gray
Write-Host "   DESPUÉS: <img src='../imagenes/Portada.png'>" -ForegroundColor Green

Write-Host "`n🎉 ¡Corrección completada!" -ForegroundColor Cyan

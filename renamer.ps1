# to run: powershell -ExecutionPolicy Bypass -File "renamer.ps1"
# Configurazione cartelle
$source = "L:\denis"
$dest = "L:\denisDefinitivo\tentativo_1"

# Crea la cartella di destinazione se non esiste
if (-not (Test-Path $dest)) {
    New-Item -ItemType Directory -Path $dest | Out-Null
}

# Inizializza il progressivo
$counter = 1

# Recupera tutti i file, ricorsivamente
Get-ChildItem -Path $source -Recurse -File | ForEach-Object {
    $file = $_
    $modYear = $file.LastWriteTime.ToString("yyyy")
    $modMonth = $file.LastWriteTime.ToString("MM")
    $filename = $file.BaseName
    $extension = $file.Extension.TrimStart('.')

    # Costruisce il nuovo nome file
    $newname = "{0}-{1}-{2}-{3}.{4}" -f $modYear, $modMonth, $filename, $counter, $extension

    # Copia il file rinominandolo nella nuova cartella
    Copy-Item -Path $file.FullName -Destination (Join-Path $dest $newname)

    Write-Host "Copiato: $($file.FullName) -> $dest\$newname"

    $counter++
}
Write-Host ""
Write-Host "Operazione completata. Totale file elaborati: $($counter-1)"
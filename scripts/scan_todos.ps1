# TODO-Scanner für PowerShell
# Speichern als scripts\scan_todos.ps1
# Sucht alle TODO-Kommentare im Code und schreibt sie in eine zentrale Datei

$searchPaths = @('lib', 'test', 'application', 'core', 'presentation')
$outputFile = 'TODOs_aus_Code.md'

# Vorherige Datei löschen
if (Test-Path $outputFile) { Remove-Item $outputFile }

Add-Content $outputFile "# Automatisch gescannte TODOs aus dem Code (Stand: $(Get-Date -Format 'yyyy-MM-dd'))`n"

foreach ($path in $searchPaths) {
    if (Test-Path $path) {
        $todos = Select-String -Path "$path/**/*.dart" -Pattern '// TODO:' -SimpleMatch -ErrorAction SilentlyContinue
        foreach ($todo in $todos) {
            $relPath = $todo.Path.Replace((Get-Location).Path + '\\', '')
            Add-Content $outputFile ("- [$relPath:$($todo.LineNumber)] $($todo.Line.Trim())")
        }
    }
}

Write-Host "Alle TODOs wurden nach $outputFile exportiert."

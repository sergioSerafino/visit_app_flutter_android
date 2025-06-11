# Skript: scripts/device_info_to_md.ps1
# Liest Ger�teinfos per adb aus und erg�nzt sie als Markdown-Tabelle in DEVICES.md

param(
    [string]$deviceId
)

if (-not $deviceId) {
    Write-Host "Bitte Device-ID als Parameter angeben! Beispiel: scripts\device_info_to_md.ps1 <Device-ID>"
    exit 1
}

$deviceProps = @{
    Modell = (adb -s $deviceId shell getprop ro.product.model).Trim()
    Hersteller = (adb -s $deviceId shell getprop ro.product.manufacturer).Trim()
    Android = (adb -s $deviceId shell getprop ro.build.version.release).Trim()
    Aufloesung = (adb -s $deviceId shell wm size | Select-String -Pattern 'Physical size: (.*)' | ForEach-Object { $_.Matches[0].Groups[1].Value }).Trim()
    Dichte = (adb -s $deviceId shell wm density | Select-String -Pattern 'Physical density: (\d+)' | ForEach-Object { $_.Matches[0].Groups[1].Value }).Trim()
    Seriennummer = (adb -s $deviceId get-serialno).Trim()
}

# Pr�fe, ob die Zeile schon existiert (Modell und Hersteller)
$mdPath = "DEVICES.md"
$mdContent = Get-Content $mdPath
$mdLine = "| $($deviceProps.Modell)                 | $($deviceProps.Hersteller)    | $($deviceProps.Android)              | $($deviceProps.Aufloesung)       | $($deviceProps.Dichte)               |                  |                       |"

if ($mdContent -contains $mdLine) {
    Write-Host "Ger�tezeile existiert bereits in DEVICES.md."
    exit 0
}

# Finde die Tabelle und h�nge die neue Zeile nach der letzten Ger�tezeile an
$tableStart = ($mdContent | Select-String -Pattern '^\| Name/Modell').LineNumber - 1
$tableEnd = ($mdContent | Select-String -Pattern '^<!-- Weitere Ger�te hier erg�nzen -->').LineNumber - 2
$before = $mdContent[0..$tableEnd]
$after = $mdContent[($tableEnd+1)..($mdContent.Length-1)]
$mdContent = $before + $mdLine + $after

# Schreibe zur�ck
$mdContent | Set-Content $mdPath

Write-Host "Ger�teinfos wurden in DEVICES.md eingetragen:"
Write-Host $mdLine

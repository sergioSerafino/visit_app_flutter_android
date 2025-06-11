# PowerShell-Skript: Android AVD für Samsung Galaxy A21s (SM-A217F) anlegen
#
# Dieses Skript legt ein neues Android Virtual Device (AVD) mit den Abmessungen und Eigenschaften
des Samsung Galaxy A21s an. Voraussetzung: Android SDK ist installiert und die Tools sind im PATH.
#
# Nutzung:
#   powershell.exe -ExecutionPolicy Bypass -File .\create_a21s_avd.ps1

# Parameter
$avdName = "A21s_Layout"
$deviceName = "Samsung Galaxy A21s"
$resolution = "720x1600"
$dpi = 270
$ram = 2048 # MB
$sdcard = "2048M"
$apiLevel = "31" # Android 12 (anpassen, falls gewünscht)
$systemImage = "system-images;android-$apiLevel;google_apis;x86_64"

# Setze SDK-Pfad (anpassen, falls nötig)
$sdkRoot = "G:\android\sdk"
$avdmanager = "$sdkRoot\cmdline-tools\latest\bin\avdmanager.bat"
$sdkmanager = "$sdkRoot\cmdline-tools\latest\bin\sdkmanager.bat"

# 1. System-Image installieren (falls nicht vorhanden)
Write-Host "Installiere System-Image: $systemImage ..."
& $sdkmanager --install $systemImage

# 2. Hardware-Profil als .ini-Datei anlegen
echo "name=$deviceName`ndevice=custom`nresolution=$resolution`ndpi=$dpi`nram=$ram`nsdcard.size=$sdcard" | Out-File "$env:TEMP\$avdName.ini" -Encoding ascii

# 3. AVD anlegen
Write-Host "Lege AVD '$avdName' an ..."
& $avdmanager create avd -n $avdName -k $systemImage --device "pixel" --force

# 4. Konfiguration anpassen
$iniPath = "$env:USERPROFILE\.android\avd\$avdName.avd\config.ini"
if (Test-Path $iniPath) {
    (Get-Content $iniPath) |
        ForEach-Object {
            $_ -replace "^hw.lcd.density=.*", "hw.lcd.density=$dpi" `
               -replace "^hw.ramSize=.*", "hw.ramSize=$ram" `
               -replace "^disk.dataPartition.size=.*", "disk.dataPartition.size=$sdcard" `
               -replace "^skin.name=.*", "skin.name=$resolution" `
               -replace "^skin.path=.*", "skin.path=_no_skin" 
        } | Set-Content $iniPath
    Add-Content $iniPath "hw.device.name=$deviceName"
    Add-Content $iniPath "hw.lcd.width=720"
    Add-Content $iniPath "hw.lcd.height=1600"
    Add-Content $iniPath "hw.lcd.density=$dpi"
}

Write-Host "AVD '$avdName' wurde erstellt und konfiguriert."
Write-Host "Starte den Emulator mit:"
Write-Host "  & '$sdkRoot\emulator\emulator.exe' -avd $avdName -gpu swiftshader_indirect -verbose"

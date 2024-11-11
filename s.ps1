Write-Output "hello world!"
Write-Output "file should be gone yay :D"

Set-Location $HOME\Downloads
New-Item "No.txt"
Set-Content -Path .\No.txt -Value "No Perhaps?" 
notepad.exe "No.txt"

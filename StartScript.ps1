Write-Output "hello world!"
Write-Output "file should be gone yay :D"

Set-Location $HOME\Downloads
New-Item "No.txt" -Value "NO"
notepad.exe "No.txt"
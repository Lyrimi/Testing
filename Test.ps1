function DoSendKeys {
    param (
        $SENDKEYS,
        $WINDOWTITLE
    )
    $wshell = New-Object -ComObject wscript.shell;
    IF ($WINDOWTITLE) {$wshell.AppActivate($WINDOWTITLE)}
    Start-Sleep(1)
    IF ($SENDKEYS) {$wshell.SendKeys($SENDKEYS)}
}

#DoSendKeys -SENDKEYS '%{f4}'

while ($true) {
    Start-Sleep(1)
    $randnum = Get-Random(10)
    if ($randnum -eq 0) {
        DoSendKeys -SENDKEYS 'a'
    }
}

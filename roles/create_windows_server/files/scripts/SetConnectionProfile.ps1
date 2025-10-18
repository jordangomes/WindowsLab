param(
    $Interface
)

Start-Transcript "C:\SetIP.log"

Set-NetConnectionProfile -InterfaceAlias $Interface -NetworkCategory Private

Start-Sleep -Seconds 5

Stop-Transcript

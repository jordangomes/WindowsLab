param(
    $Interface,
    $IPAddress,
    $IPV4Prefix,
    $DefaultGateway,
    $DNS1,
    $DNS2
)

Start-Transcript "C:\SetIP.log"

Write-Host "Setting static IP and DNS on $Interface"
Write-Host "IP: $IPAddress/$IPV4Prefix"
Write-Host "Gateway: $DefaultGateway"
Write-Host "DNS1: $DNS1"
Write-Host "DNS2: $DNS2"

Start-Sleep -Seconds 5

New-NetIPAddress -InterfaceAlias $Interface -IPAddress $IPAddress -PrefixLength $IPV4Prefix -DefaultGateway $DefaultGateway
Set-DNSClientServerAddress -InterfaceAlias $Interface -ServerAddresses @($DNS1, $DNS2)


Start-Sleep -Seconds 5

Stop-Transcript

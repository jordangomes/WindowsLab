<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="windowsPE">
        <component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <SetupUILanguage>
                <UILanguage>en-US</UILanguage>
            </SetupUILanguage>
            <InputLocale>en-US</InputLocale>
            <SystemLocale>en-US</SystemLocale>
            <UILanguage>en-US</UILanguage>
            <UILanguageFallback>en-US</UILanguageFallback>
            <UserLocale>en-US</UserLocale>
        </component>
        <component name="Microsoft-Windows-PnpCustomizationsWinPE" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" processorArchitecture="amd64" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <DriverPaths>
                <PathAndCredentials wcm:action="add" wcm:keyValue="1">
                    <Path>e:\virtio\amd64</Path>
                </PathAndCredentials>
            </DriverPaths>
        </component>           
        <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <DiskConfiguration>
                <Disk wcm:action="add">
                    <CreatePartitions>
                        <CreatePartition wcm:action="add">
                            <Order>1</Order>
                            <Type>Primary</Type>
                            <Extend>true</Extend>
                        </CreatePartition>
                    </CreatePartitions>
                    <ModifyPartitions>
                        <ModifyPartition wcm:action="add">
                            <Format>NTFS</Format>
                            <Label>System</Label>
                            <Letter>C</Letter>
                            <Order>1</Order>
                            <PartitionID>1</PartitionID>
                        </ModifyPartition>
                    </ModifyPartitions>
                    <DiskID>0</DiskID>
                    <WillWipeDisk>true</WillWipeDisk>
                </Disk>
            </DiskConfiguration>
            <ImageInstall>
                <OSImage>
                    <InstallFrom>
                        <MetaData wcm:action="add">
                            <Key>/IMAGE/NAME</Key>
                            <Value>{{deploy_image}}</Value>
                        </MetaData>
                    </InstallFrom>
                    <InstallTo>
                        <DiskID>0</DiskID>
                        <PartitionID>1</PartitionID>
                    </InstallTo>
                </OSImage>
            </ImageInstall>
            <UserData>
                <!-- Product Key from https://www.microsoft.com/de-de/evalcenter/evaluate-windows-server-technical-preview?i=1 -->
                <ProductKey>
                    <!-- Do not uncomment the Key element if you are using trial ISOs -->
                    <!-- You must uncomment the Key element (and optionally insert your own key) if you are using retail or volume license ISOs -->
                    <!-- <Key>6XBNX-4JQGW-QX6QG-74P76-72V67</Key> -->
                    <WillShowUI>OnError</WillShowUI>
                </ProductKey>
                <AcceptEula>true</AcceptEula>
                <FullName>Administrator</FullName>
                <Organization>{{org_name}}</Organization>
            </UserData>
        </component>
    </settings>
    <settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <OEMInformation>
                <HelpCustomized>false</HelpCustomized>
            </OEMInformation>
            <ComputerName>{{vm_hostname}}</ComputerName>
            <TimeZone>{{vm_time_zone}}</TimeZone>
            <RegisteredOwner/>
        </component>
        <component name="Microsoft-Windows-TerminalServices-LocalSessionManager" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <fDenyTSConnections>false</fDenyTSConnections>
        </component>
        <component name="Microsoft-Windows-ServerManager-SvrMgrNc" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <DoNotOpenServerManagerAtLogon>true</DoNotOpenServerManagerAtLogon>
        </component>
        <component name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <SkipAutoActivation>true</SkipAutoActivation>
        </component>                  
    </settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <AutoLogon>
                <Username>Administrator</Username>
                <Password>
                    <Value>{{vm_admin_pass}}</Value>
                    <PlainText>true</PlainText>
                </Password>
                <Enabled>true</Enabled>
                <LogonCount>2</LogonCount>
            </AutoLogon>            
            <FirstLogonCommands>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff /f</CommandLine>
                    <Order>1</Order>
                    <Description>Disable Network Discovery Prompt</Description>
                </SynchronousCommand>
{% if agent is match("enabled=1") %}
                <SynchronousCommand wcm:action="add">
                    <CommandLine>e:\virtio\amd64\qemu-ga-x86_64.msi /quiet</CommandLine>
                    <Order>2</Order>
                    <Description>Install qemu-guest-agent</Description>
                </SynchronousCommand>
{% endif %}
{% if static_ip %}
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell -NoProfile -ExecutionPolicy Bypass -Command "&'E:\scripts\SetIPAndDNS.ps1' -Interface '{{ network_interface }}' -IPAddress '{{ ip_address }}' -IPV4Prefix '{{ ipv4_prefix }}' -DefaultGateway '{{ default_gateway }}' -DNS1 '{{ dns_1}}' -DNS2 '{{ dns_2 }}'"</CommandLine>
                    <Order>3</Order>
                    <Description>Set Static IP Address and DNS Settings</Description>
                </SynchronousCommand>
{% endif %}
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell -File e:\scripts\AnsiblePrep.ps1</CommandLine>
                    <Description>Configure Ansible Prep and WinRM</Description>
                    <Order>4</Order>
                </SynchronousCommand>   
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell -File e:\scripts\win-updates-pass1.ps1</CommandLine>
                    <Description>Install Get-WindowsUpdate module and Windows Updates Pass 1</Description>
                    <Order>5</Order>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell Start-Sleep -Seconds 20</CommandLine>
                    <Description>Insert a pause to prevent update pass 2 from starting just before reboot</Description>
                    <Order>6</Order>
                </SynchronousCommand>                    
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell -File e:\scripts\win-updates-pass2.ps1</CommandLine>
                    <Description>Install Windows Updates Pass 2</Description>
                    <Order>7</Order>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell Start-Sleep -Seconds 25</CommandLine>
                    <Description>Insert a pause to prevent shutdown before reboor</Description>
                    <Order>8</Order>
                </SynchronousCommand>                    
                <SynchronousCommand wcm:action="add">
                    <CommandLine>shutdown -s -t 0</CommandLine>
                    <Description>Shutdown VM</Description>
                    <Order>9</Order>
                </SynchronousCommand>                    
            </FirstLogonCommands>
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideLocalAccountScreen>true</HideLocalAccountScreen>
                <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
                <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
                <NetworkLocation>Home</NetworkLocation>
                <ProtectYourPC>1</ProtectYourPC>
            </OOBE>
            <UserAccounts>
                <AdministratorPassword>
                    <Value>{{vm_admin_pass}}</Value>
                    <PlainText>true</PlainText>
                </AdministratorPassword>
            </UserAccounts>
            <RegisteredOwner />
        </component>
    </settings>
</unattend>

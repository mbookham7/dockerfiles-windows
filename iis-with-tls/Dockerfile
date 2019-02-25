# escape=`
FROM microsoft/aspnet:3.5-20180814-windowsservercore-ltsc2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

COPY site C:\inetpub\wwwroot

RUN Import-Module WebAdministration; `
    New-SelfSignedCertificate -DnsName 'mikebookham.co.uk' -CertStoreLocation 'Cert:\LocalMachine\My'; `
    $Key = ChildItem -path cert:\LocalMachine\My | Select-Object $_.Thumbprint; `
    $cert = $key.Thumbprint; `
    $webapplicationname = 'Default Web Site'; `
    $IPAdress = '*'; `
    $Port = '443'; `
    $Hostheader = '*'; `   
    $Protocol = 'https'; `
    New-WebBinding -Name $webapplicationname -IPAddress $IPAdress -Port $Port -HostHeader $Hostheader -Protocol $Protocol; `
    cd IIS:\SslBindings; `
    get-item "Cert:\LocalMachine\My\$cert" | new-item $IPAdress!$Port;

    EXPOSE 443
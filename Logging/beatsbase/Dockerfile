# escape=`
FROM microsoft/windowsservercore AS downloader
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV WL_VERSION="6.2.3" `
    WL_HOME="C:\Winlogbeat"

RUN Invoke-WebRequest "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-$($env:WL_VERSION)-windows-x86_64.zip.sha512" -OutFile 'winlogbeats.zip.sha512' -UseBasicParsing; `
    $env:ES_SHA512 = Get-Content -Raw winlogbeats.zip.sha512; `
    Invoke-WebRequest "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-$($env:WL_VERSION)-windows-x86_64.zip" -OutFile 'winlogbeats.zip' -UseBasicParsing; `
    Expand-Archive winlogbeats.zip -DestinationPath C:\ ; `
    Move-Item c:/winlogbeat-$($env:WL_VERSION)-windows-x86_64 $env:WL_HOME;

# basewithmonitoring
FROM microsoft/windowsservercore:ltsc2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV WL_VERSION="6.2.3" `
    WL_HOME="C:\Program Files\Winlogbeat"

WORKDIR $WL_HOME


COPY --from=downloader "C:\Winlogbeat" .

# Default configuration for host & Elasticsearch URL
COPY winlogbeat.yml .

# Install Windows Service for Winlogbeat
RUN .\install-service-winlogbeat.ps1

RUN Set-Service -Name winlogbeat -StartupType Automatic; `
    Start-Service winlogbeat;
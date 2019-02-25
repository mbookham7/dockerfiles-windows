# escape=`
FROM microsoft/windowsservercore AS downloader
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV FB_VERSION="6.2.3" `
    FB_HOME="C:\filebeat"

RUN Invoke-WebRequest "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$($env:FB_VERSION)-windows-x86_64.zip.sha512" -OutFile 'filebeat.zip.sha512' -UseBasicParsing; `
    $env:ES_SHA512 = Get-Content -Raw filebeat.zip.sha512; `
    Invoke-WebRequest "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$($env:FB_VERSION)-windows-x86_64.zip" -OutFile 'filebeat.zip' -UseBasicParsing; `
    Expand-Archive filebeat.zip -DestinationPath C:\ ; `
    Move-Item c:/filebeat-$($env:FB_VERSION)-windows-x86_64 $env:FB_HOME;

# basewithmonitoring
FROM microsoft/aspnet:3.5-windowsservercore-10.0.14393.1884
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV FB_VERSION="6.2.3" `
    FB_HOME="C:\Program Files\filebeat"

WORKDIR $FB_HOME


COPY --from=downloader "C:\filebeat" .

# Default configuration for host & Elasticsearch URL
COPY filebeat.yml .

# Install Windows Service for Winlogbeat
RUN .\install-service-filebeat.ps1

RUN Set-Service -Name filebeat -StartupType Automatic
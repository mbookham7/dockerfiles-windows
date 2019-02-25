# escape=`
FROM microsoft/aspnet:3.5-windowsservercore-10.0.14393.1884
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV FB_VERSION="6.3" `
    FB_HOME="C:\Program Files\filebeat"

WORKDIR $FB_HOME

COPY .\6.3 .

# Default configuration for host & Elasticsearch URL
COPY filebeat.yml .

# Install Windows Service for Winlogbeat
RUN .\install-service-filebeat.ps1

RUN Set-Service -Name filebeat -StartupType Automatic; `
    Start-Service filebeat;
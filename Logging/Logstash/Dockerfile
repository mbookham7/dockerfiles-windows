# escape=`
FROM microsoft/windowsservercore AS downloader
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV LS_VERSION="6.2.4" `
    LS_HOME="C:\Logstash"

RUN [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;`
    Invoke-WebRequest "https://artifacts.elastic.co/downloads/logstash/logstash-$($env:LS_VERSION).zip" -OutFile 'logstash.zip' -UseBasicParsing; `
    Expand-Archive logstash.zip -DestinationPath C:\ ; `
    Move-Item c:/logstash-$($env:LS_VERSION) $env:LS_HOME;

# Run Container
FROM openjdk:8-nanoserver-sac2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV LS_VERSION="5.6.4" `
    LS_HOME="C:\Logstash"

# Volume and drive mount
VOLUME C:\Logs
RUN Set-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices' -Name 'G:' -Value '\??\C:\Logs' -Type String

EXPOSE 9200 9300
SHELL ["cmd", "/S", "/C"]

CMD ".\bin\logstash.bat -f .\config\logstashwin.conf"
WORKDIR $LS_HOME
COPY --from=downloader C:\Logstash\ .
COPY config ./config

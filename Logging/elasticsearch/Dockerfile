# escape=`
FROM microsoft/windowsservercore AS downloader
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV ES_VERSION="6.2.3" `
    ES_HOME="C:\elasticsearch"

RUN Invoke-WebRequest "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$($env:ES_VERSION).zip.sha512" -OutFile 'elasticsearch.zip.sha512' -UseBasicParsing; `
    $env:ES_SHA512 = Get-Content -Raw elasticsearch.zip.sha512; `
    Invoke-WebRequest "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$($env:ES_VERSION).zip" -OutFile 'elasticsearch.zip' -UseBasicParsing; `
    Expand-Archive elasticsearch.zip -DestinationPath C:\ ; `
    Move-Item c:/elasticsearch-$($env:ES_VERSION) $env:ES_HOME;

# Elasticsearch
FROM openjdk:8-nanoserver-sac2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV ES_VERSION="6.2.3" `
    ES_HOME="C:\elasticsearch"

# Volume and drive mount
VOLUME C:\data
RUN Set-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices' -Name 'G:' -Value '\??\C:\data' -Type String    
   
EXPOSE 9200 9300
SHELL ["cmd", "/S", "/C"]
CMD ".\bin\elasticsearch.bat"

WORKDIR $ES_HOME
COPY --from=downloader C:\elasticsearch\ .
COPY config ./config

HEALTHCHECK --interval=5s `
 CMD powershell -command `
    try { `
     $content = (iwr -useb http://localhost:9200/_cat/health).Content; `
     $health = $content.Split(' ')[3]; `
     if ($health -eq 'green' -or $health -eq 'yellow') { return 0 } `
     else { return 1 }; `
    } catch { return 1 }
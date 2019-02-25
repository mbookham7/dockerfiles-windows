# escape=`
FROM microsoft/windowsservercore:ltsc2016 AS downloader
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV KIBANA_VERSION="6.2.3" `
    KIBANA_HOME="C:\kibana"

RUN Invoke-WebRequest "https://artifacts.elastic.co/downloads/kibana/kibana-$($env:KIBANA_VERSION)-windows-x86_64.zip.sha512" -OutFile 'kibana.zip.sha512' -UseBasicParsing; `
    Invoke-WebRequest "https://artifacts.elastic.co/downloads/kibana/kibana-$($env:KIBANA_VERSION)-windows-x86_64.zip" -OutFile 'kibana.zip' -UseBasicParsing; `
    Expand-Archive kibana.zip -DestinationPath C:\; `
    Move-Item c:/kibana-$($env:KIBANA_VERSION)-windows-x86_64 $env:KIBANA_HOME;

# Kibana
FROM microsoft/windowsservercore:ltsc2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV KIBANA_VERSION="6.2.3" `
    KIBANA_HOME="C:\kibana"

EXPOSE 5601
ENTRYPOINT ["powershell"]
CMD ["./init.ps1"]

WORKDIR C:/kibana
COPY init.ps1 .
COPY --from=downloader C:\kibana\ .

# Default configuration for host & Elasticsearch URL
RUN (Get-Content ./config/kibana.yml) -replace '#server.host: \"localhost\"', 'server.host: \"0.0.0.0\"' | Set-Content ./config/kibana.yml; `
    (Get-Content ./config/kibana.yml) -replace '#elasticsearch.url: \"http://localhost:9200\"', 'elasticsearch.url: \"http://elasticsearch:9200\"' | Set-Content ./config/kibana.yml

HEALTHCHECK --start-period=30s --interval=10s --retries=5 `
 CMD powershell -command `
    try { `
     $response = iwr -useb http://localhost:5601/app/kibana; `
     if ($response.StatusCode -eq 200) { return 0} `
     else {return 1}; `
    } catch { return 1 }
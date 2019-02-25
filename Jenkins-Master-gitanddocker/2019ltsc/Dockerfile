# escape=`
FROM mikebookhamcap/jenkins-master:2.121.1-windowsservercore-ltsc2019
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:\git
COPY --from=mikebookhamcap/git:2.17.1-windowsservercore-ltsc2019 C:\git .

WORKDIR C:\docker
COPY --from=mikebookhamcap/docker-cli:18.06.1-windowsservercore-ltsc2019 ["C:\\Program Files\\Docker",  "."]

RUN $env:PATH = 'C:\docker;' + 'C:\git\cmd;C:\git\mingw64\bin;C:\git\usr\bin;' + $env:PATH; `
	[Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)
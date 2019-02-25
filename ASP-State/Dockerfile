# escape=`
FROM microsoft/mssql-server-windows-express:latest
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR /

# enable SA user (set appropriate password below - this could be done through environment variables in the .\Start2.ps1 script - would have to reset the password after the ASPState database is created)
RUN start-service MSSQL`$SQLEXPRESS; `
    Invoke-Sqlcmd -Query 'ALTER LOGIN sa with password=''password.1'';' -ServerInstance "localhost"; `
    Invoke-Sqlcmd -Query 'ALTER LOGIN sa ENABLE;' -ServerInstance "localhost";

# create the ASPState database
RUN C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet_regsql.exe -ssadd -sstype p -S localhost -U sa -P password.1

# create a login (set appropriate name and password, again this could be done through environment variables in the .\Start2.ps1 script)
RUN Invoke-Sqlcmd -Query 'CREATE LOGIN aspstateuser WITH PASSWORD=''password.1'''; `
    Invoke-Sqlcmd -Query 'USE ASPState; CREATE USER aspstateuser FOR LOGIN aspstateuser; GRANT EXECUTE TO aspstateuser'; `
    stop-service MSSQL`$SQLEXPRESS

# copy the start script, this is a cut-down version of the script used in the base image
COPY Start2.ps1 /
 
# expose the SQL port
EXPOSE 1433

# set the start command that will run on container start (basically just starts the service and then loops round)
CMD .\Start2.ps1 -Verbose

#########
# Author: Paloma García
# Description: Script que muestra eventos de todos los servidores
# y permite listar, generar documento html o borrar.
#########
$path="\inetpub\wwwroot\prueba\"
Get-ADComputer -Properties * -Filter * |select ipv4address| ConvertTo-Csv > ip_servidores.csv

Import-Csv .\ip_servidores.csv|foreach{
    $ip=$_.ipv4address

    Get-Eventlog -Computer $ip -List |select log | ConvertTo-Csv > log_sevidores.csv

    Import-Csv .\log_servidores.csv|foreach{
        $log=$_.log
        cls
        Write-Host "Estos son todos los logs registrados del sistema"
        Get-EventLog -List
        $confir=Read-Host "Desea visualizar los eventos de $log s/n"
    
        if ($confir -eq 's')
            {
            $opcion = Read-Host "Introduzca un tipo de entrada (Error,Information,FailureAudit,SuccessAudit,Warning) "
            $web=Read-Host "Desea generar un documento html del log $log y tipo de entrada $opcion s/n"
            if ($web -eq "s"){
                Get-EventLog -Computer $ip -Logname $log -EntryType $opcion
                Get-Eventlog -Computer $ip -LogName $log -EntryType $opcion |select eventid,message |convertTo-html -Title "Log $nombrelog Tipo $opcion" -Head '<meta http-equiv="refresh" content="5">' -pre "<h1>LOG $nombrelog TIPO $opcion</h1>" > $pathLogs$nombrelog.html;ii $pathLogs$nombrelog.html
                }
            else {Read-Host "Pulse una tecla"}        
            }
            $borrar = Read-Host "Desea eliminar logs de $log s/n"
            if ($borrar -eq "s"){
                Clear-EventLog -LogName $log
            else {Read-Host "Pulse una tecla"}
            }
        else {Read-Host "Pulse una tecla"}
    }

}
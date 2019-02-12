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
        $nombrelog=$_.log
        cls
        Write-Host "Estos son todos los logs registrados del sistema"
        Get-EventLog -List
        $confir=Read-Host "Desea visualizar los eventos de $nombrelog s/n"
    
        if ($confir -eq 's')
            {
            $opcion = Read-Host "Introduzca un tipo de entrada (Error,Information,FailureAudit,SuccessAudit,Warning) "
            $web=Read-Host "Desea generar un documento html del log $nombrelog y tipo de entrada $opcion s/n"
            if ($web -eq "s"){
                Get-EventLog -Computer $ip -Logname $nombrelog -EntryType $opcion
                Get-Eventlog -Computer $ip -LogName $nombrelog -EntryType $opcion |select eventid,message |convertTo-html -Title "Log $nombrelog Tipo $opcion" -Head '<meta http-equiv="refresh" content="5">' -pre "<h1>LOG $nombrelog TIPO $opcion</h1>" > $pathLogs$nombrelog.html;ii $pathLogs$nombrelog.html
                }
            else {Write-Host "No se creo la página html"}        
            }
            $borrar = Read-Host "Desea eliminar logs de $nombrelog s/n"
            if ($borrar -eq "s"){
                Clear-EventLog -LogName $nombrelog
            else {Read-Host "Pulse una tecla"}
            }
        else {Write-Host "No se ha eliminado el log $nombrelog"}
    }

}

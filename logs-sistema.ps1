#########
# Author: Paloma García
# Description: Script que muestra eventos del sistema
# y permite listar, generar documento html o borrar.
#########
$path="\inetpub\wwwroot\prueba\"
cls
do{
    Write-Host "Estos son todos los logs registrados del sistema"
    Get-EventLog -List
    $nombrelog = Read-Host "Introduzca un Log "  
    $opcion = Read-Host "Introduzca un tipo de entrada (Error,Information,FailureAudit,SuccessAudit,Warning) "
    Write-Host "Se va a generar un documento html del log $nombrelog y tipo de entrada $opcion"
    Get-EventLog -Logname $nombrelog -EntryType $opcion
    Get-Eventlog -LogName $nombrelog -EntryType $opcion |select eventid,message |convertTo-html -Title "Log $nombrelog Tipo $opcion" -Head '<meta http-equiv="refresh" content="5">' -pre "<h1>LOG $nombrelog TIPO $opcion</h1>" > $pathLogs$nombrelog.html;ii $pathLogs$nombrelog.html    
    $borrar = Read-Host "Desea eliminar logs de $nombrelog s/n"
    if ($borrar -eq "s"){
        Clear-EventLog -LogName $nombrelog
    else {Read-Host "Pulse una tecla"}
    }
}until ($nombrelog -eq 's')
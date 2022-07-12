<#
.SYNOPSIS
Kurzbeschreibung: Abfrage von EventIDs
.DESCRIPTION 
LANGE BESCHREIBUNG: 
.PARAMETER EventId
Hier sind folgende Werte möglich
4624 | Anmeldung
4625 | fehlgeschlagene Anmeldung
4634 | Abmeldung
.EXAMPLE
Get-EventLog.ps1 -EventId 4634

EntryType   Source                 InstanceID Message
---------   ------                 ---------- -------
SuccessA... Microsoft-Windows...         4634 Ein Konto wurde abgemeldet....
SuccessA... Microsoft-Windows...         4634 Ein Konto wurde abgemeldet....
SuccessA... Microsoft-Windows...         4634 Ein Konto wurde abgemeldet....
SuccessA... Microsoft-Windows...         4634 Ein Konto wurde abgemeldet....
SuccessA... Microsoft-Windows...         4634 Ein Konto wurde abgemeldet....
.LINK
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.2#comment-based-help-keywords
#>
[cmdletBinding()]
param(
[Parameter(Mandatory=$true)]
[ValidateSet(4624,4625,4634)]
[int]$EventId,

[ValidateRange(1,10)]
[int]$Newest = 5,

[ValidateScript({Test-NetConnection -ComputerName $PSItem -CommonTCPPort WINRM -InformationLevel Quiet})]
[string]$Computername = "localhost",

[ValidatePattern("[a-z]{3}[0-9]{3}[.](csv)")]
[string]$FileName = "Nothing"
)

#Wird nur ausgegeben wenn das Skript mit -verbose aufgerufen wird
Write-Verbose -Message "Vom User wurden folgende Werte überbeben: $Eventid | $Newest | $computername"

$events = Get-EventLog -LogName Security -ComputerName $Computername | Where-Object EventID -eq $EventId | Select-Object -First $Newest

if($FileName -eq "Nothing")
{
    $events
}
else
{
    Export-Csv -InputObject $events -Path "C:\testFiles\$FileName"
}
[Reflection.Assembly]::LoadWithPartialName("System.Messaging")

$username = $args[0]
#load xml with server names
$relativePath = Get-Item ".\config.xml"
[xml]$XmlDoc = Get-Content -Path $relativePath
$serverExtract = New-Object System.Collections.ArrayList
$serverExtract.Add($XMLDoc.Servers.Parent.Child)

#loop thru all the servers
foreach ($servers in $serverExtract){
  foreach($server in $servers) {
    try {
        $sessionid = ((quser /server:$server | select-object -skip 1 | where-object {$_ -match $username}) -split " +")[2]
        logoff $sessionid  /server:$server /V  
    }
    catch {}
  }
}

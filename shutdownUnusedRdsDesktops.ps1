<###
This script will get all VDI's that currently don't have an active session and shut them down
###>
$collectionName = "HCC-VDI-C2"
$rdsBroker = "broker.holycross.wa.edu.au"


$vdis = Get-RDVirtualDesktop -ConnectionBroker $rdsBroker -CollectionName $collectionName
$userSessions = Get-RDUserSession -ConnectionBroker $rdsBroker -CollectionName $collectionName
$unusedVms = @()


foreach ($vdi in $vdis){
    if(!($vdi.VirtualDesktopName -in $userSessions.ServerName)){$unusedVms += $vdi.VirtualDesktopName}
}
write-host "The following VDI's will be shutown, Continue?"
$unusedVms
$continue = (read-host "Y/N").ToLower()
if ($continue -eq "y"){
    foreach ($a in $unusedVms){
        Invoke-Command -ComputerName $a -ScriptBlock {shutdown /s /t 0}
        write-host "Shut down $a"
    }
}
Else{write-host "Exiting..."}

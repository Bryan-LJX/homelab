#Optimized from https://blog.jgriffiths.org/powercli-locate-all-the-scsi-bus-sharing-vms/
#This script checks the selected vSphere cluster for any Scsi bus sharing VMs and lists out their details in Grid View
#Shows VM name, host, SCSI bus sharing mode and also the vmdk disks on each VM. This is useful to check which VMs are sharing the same disk(s)

$vCenterServer = Read-Host "`nEnter the vCenter Server to connect"
Write-Host "Connecting to vCenter Server - $vCenterServer"
Connect-VIServer $vCenterServer 
$Cluster = Read-Host "Enter the cluster name"
#Create the array

$array = @()

$vms = get-cluster "$Cluster" | get-vm

#Loop for BusSharingMode

foreach ($vm in $vms)

{

 

$disks = $vm | Get-ScsiController | Where-Object {$_.BusSharingMode -eq "Physical" -or $_.BusSharingMode -eq "Virtual"}
$harddisk = $vm | Get-HardDisk
$harddiskstring = $harddisk.Filename | Out-String


foreach ($disk in $disks){

$REPORT = New-Object -TypeName PSObject

$REPORT | Add-Member -type NoteProperty -name Name -Value $vm.Name

$REPORT | Add-Member -type NoteProperty -name VMHost -Value $vm.VMHost

$REPORT | Add-Member -type NoteProperty -name Mode -Value $disk.BusSharingMode

$REPORT | Add-Member -type NoteProperty -name Type -Value "BusSharing"

$REPORT | Add-Member -type NoteProperty -name Disks -Value $harddiskstring

$array += $REPORT

}
 

}

$array | out-gridview


Write-Host "`nDisconnecting from vCenter Server - $vCenterServer"
Disconnect-VIServer $vCenterServer -Confirm:$false

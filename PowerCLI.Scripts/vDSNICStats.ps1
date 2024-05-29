#Script that collects the CRC errors, Rx & Tx packets dropped of the selected vDS 

Write-Host -backgroundcolor Magenta "`t--- NIC Status Script ---"
$vCenterServer = Read-Host "`nEnter the vCenter Server to connect"
Write-Host "Connecting to vCenter Server - $vCenterServer"
Connect-VIServer $vCenterServer 

$report = @()
$nicStatsReport = @()
$vDSName = Read-Host "`nEnter the vSphere Distributed Switch (vDS) name"
foreach ($vds in (Get-VDSwitch | ? {$_.name -eq $vDSName}))
{
    $uuid = $vds.ExtensionData.Summary.Uuid
    $vds.ExtensionData.Config.Host | %{
        $esx = Get-View $_.Config.Host
        $netSys = Get-View $esx.ConfigManager.NetworkSystem
        $netSys.NetworkConfig.ProxySwitch | where {$_.Uuid -eq $uuid} | %{
                $_.Spec.Backing.PnicSpec | %{
                    $row = "" | Select Host,dvSwitch,PNic
                    $row.Host = $esx.Name
                    $row.dvSwitch = $vds.Name
                    $row.PNic = $_.PnicDevice
                    $report += $row            
                }
        }
    }
}
Write-Host "`n"
foreach ($entry in $report | Sort Host)
{
    $vmhost = $entry.Host
    $esxCLI = Get-EsxCli -VMHost $vmhost -V2
    $hashTable = $esxCLI.network.nic.stats.get.CreateArgs()
    $hashTable.nicname = $entry.Pnic
    $nicName = $entry.Pnic
    Write-Host "Current host: $vmhost, PNic: $nicName"
    $nicStats = $esxCLI.network.nic.stats.get.Invoke($hashTable)
    $row = "" | Select Host,dvSwitch,PNic,"Receive CRC errors","Receive packets dropped","Transmit packets dropped"
    $row.Host = $vmhost
    $row.dvSwitch = $entry.dvSwitch
    $row.PNic = $entry.NICName
    $row."Receive CRC errors" = $nicStats.ReceiveCRCerrors
    $row."Receive packets dropped" = $nicStats.Receivepacketsdropped
    $row."Transmit packets dropped" = $nicStats.Transmitpacketsdropped
    $nicStatsReport += $row
}
$fileName = "NIC-Stats-Report.csv"
$nicStatsReport | Export-Csv $fileName -NoTypeInformation

Write-Host "`nNIC stats report exported to $fileName"
Write-Host "`nDisconnecting from vCenter Server - $vCenterServer"
Disconnect-VIServer $vCenterServer -Confirm:$false

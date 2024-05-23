$vcserver = Read-Host -Prompt "Enter Host/vCenter FQDN or IP Address"

connect-VIServer $vcserver

get-vm | select name,powerstate | Format-Table *
$VMname = Read-Host -Prompt "Which VM would you like to select"
$TurnOnOff = Read-Host -Prompt "Would you like to Power On (1) or Power Off (0)"
$VM01 = get-vm "$VMname"
$ipaddr01 = $VM01.guest.ipaddress[0]
$VM01pwrstate = $VM01.powerstate


if ($TurnOnOff -eq "1") {

	start-vm -VM $VM01 -RunAsync | Out-Null
	start-sleep -seconds 15

$VM01 = get-vm "$VMname"
$VM01 | select name,powerstate
"$VMname is still starting up. Please wait..."
while ($ipaddr01 -eq $null) {
	$VM01 = get-vm "$VMname"
	$ipaddr01 = $VM01.guest.ipaddress[0]
	start-sleep -seconds 5
}
$VM01 = get-vm "$VMname"
$VM01 | select name, @{N="IP Address";E={$_.Guest.IPAddress[0]}}
"$VMname has started up!"

}elseif ($TurnOnOff -eq "0") {
	
	shutdown-vmguest -VM $VM01 -Confirm:$false | Out-Null
	start-sleep -seconds 15
"$VMname is shutting down. Please wait..."
	while (($VM01pwrstate -eq "PoweredOn")) {
	$VM01 = get-vm "$VMname"
    $VM01pwrstate = $VM01.powerstate
	start-sleep -seconds 5
}

$VM01 = get-vm "$VMname"
$VM01 | select name,powerstate
"$VMname has shutdown succesfully."
	
}else {
	"Invalid input! Exiting..,"
}

disconnect-VIServer $vcserver -Confirm:$false
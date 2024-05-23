# A simple ESXi Host shutdown script which I use to power down my home lab. 
# Credentials for each host have been saved beforehand in the PowerCLI credential store via the New-VICredentialStoreItem cmdlet

# shutdown host lab-esxi01
"Connecting to lab-esxi01..."
connect-VIServer 192.168.1.82
stop-vmhost -vmhost 192.168.1.82 -Force -Confirm:$false | Out-Null
"lab-esxi01 shutdown initiated"
disconnect-VIServer 192.168.1.82 -Confirm:$false

start-sleep -seconds 5

# shutdown host lab-esxi02
"Connecting to lab-esxi02..."
connect-VIServer 192.168.1.92
stop-vmhost -vmhost 192.168.1.92 -Force -Confirm:$false | Out-Null
"lab-esxi02 shutdown initiated"
disconnect-VIServer 192.168.1.92 -Confirm:$false

start-sleep -seconds 5

# shutdown host lab-esxi03
"Connecting to lab-esxi03..."
connect-VIServer 192.168.1.102
stop-vmhost -vmhost 192.168.1.102 -Force -Confirm:$false | Out-Null
"lab-esxi03 shutdown initiated"
disconnect-VIServer 192.168.1.102 -Confirm:$false

start-sleep -seconds 5

# shutdown host lab-esxi04
"Connecting to lab-esxi04..."
connect-VIServer 192.168.1.190
stop-vmhost -vmhost 192.168.1.190 -Force -Confirm:$false | Out-Null
"lab-esxi04 shutdown initiated"
disconnect-VIServer 192.168.1.190 -Confirm:$false

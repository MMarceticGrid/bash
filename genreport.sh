#!/bin/bash

echo "REPORT"
echo "------------"
echo "Current date and time: `date`"
echo "Name of current user: `whoami`"
echo "Internal IP address: `ipconfig getifaddr en0`"
echo "External IP address: `curl -s ifconfig.me`"
echo "Hostname is: `hostname`" 
sw_vers | grep Product
echo "Mac uptime: `uptime`"
df -h / | awk 'NR==2 {print "Used memory: " $3}'    
df -h / | awk 'NR==2 {print "Free memory: " $4}'    
top -l 1 -s 0 | grep PhysMem | awk '{print "Total RAM: " $2}'
top -l 1 -s 0 | grep PhysMem | awk '{print "Free RAM: " $8}'
echo "Total number of CPU cores: `sysctl -n hw.ncpu`"  
echo "Frequency of CPU is: `sysctl -n hw.cpufrequency`"

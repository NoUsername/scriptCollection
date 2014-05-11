#!/bin/bash

LOGFILE=${HOME}/inetCheck.log

hasInet(){
	COUNT=3
	TESTHOST="8.8.8.8"
	MYIP="192.168.1.2/"
	MYNWIF="eth0"
	match=$(ip addr show $MYNWIF | grep $MYIP)
	if [[ "$match" == "" ]]; then
	  echo "wrong ip address"
	  return 1
	else
	  echo "ip address ok, checking ping"
	fi
	count=$(ping -c $COUNT $TESTHOST > /dev/null 2>&1 ; echo $?)
	if [[ "$count" != "0" ]]; then
	  echo "inet down"
	  return 1
	else
	  echo "inet ok"
	  return 0
	fi
}

if ( hasInet )
then
  echo $(date)": testing inet successful on first try" >> $LOGFILE
  echo "all ok"
  exit 0
fi

echo "waiting..."
sleep 30
echo "retrying"

if ( hasInet )
then
  echo "ok now"
  exit 0
fi

restartNetworking() {
	sudo nohup sh -c "invoke-rc.d networking stop; sleep 2; invoke-rc.d networking start"
	sleep 10
	sudo nohup sh -c "ifconfig wlan0 up"
}

echo "still no inet, trying to restart network"
echo $(date)": restarting nw daemon to get inet back" >> $LOGFILE
#bash  /etc/init.d/networking restart
restartNetworking

sleep 30
if ( hasInet )
then
  echo "finally working after nw restart"
  exit 0
fi

echo "wainting and will try to restart if nothing has helped"
sleep 180 # wait 3 minutes

if ( hasInet )
then
  echo "no need to restart, we have inet now"
  exit 0
fi

echo $(date)": restarting to try to fix inet connection" >> $LOGFILE
echo "restarting"
shutdown -r +1

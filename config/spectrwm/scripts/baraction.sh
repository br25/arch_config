#!/bin/bash
# baraction.sh for spectrwm status bar

## DISK
hdd() {
	 hdd="$(df -h | awk 'NR==4{print $3, $5}')"
	 echo -e "HDD: $hdd"
}


## RAM
mem() {
	 mem=`free | awk '/Mem/ {printf "%dM/%dM\n", $3 / 1024.0, $2 / 1024.0 }'`
	 echo -e "$mem"
}


## CPU
cpu() {
	 read cpu a b c previdle rest < /proc/stat
	 prevtotal=$((a+b+c+previdle))
	 sleep 0.5
	 read cpu a b c idle rest < /proc/stat
	 total=$((a+b+c+idle))
	 cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
	 echo -e "CPU: $cpu%"
}

#net() {
#	SCRIPT_PATH="/home/oreo/bin/netspeed"
#	net=$("$SCRIPT_PATH")
#	echo -e "NET: $net"
#}


#updates() {
#	SCRIPT_PATH="/home/oreo/updates.sh"
#	updates=$("$SCRIPT_PATH")
#	echo -e "UPDATES: $updates"
#}


##DATE&TIME
dte() {
	dte="$(date + "%A,%B %d %l:%M%p")"
	echo -e "DATE: $dte"
}

##WIFI
#wlan(){
#	IWCONFIG=/sbin/iwconfig
#	PROC_WIFI=/proc/net/wireless
#	WLAN_IFACE=$(cat ${PROC_WIFI} | awk 'END{gsub(":","",$1); print $1}')
#	ESSID=`${IWCONFIG} $(echo $WLAN_IFACE) | awk 'NR>1 {exit} {print $NF}'`
#	eval $(cat ${PROC_WIFI} | awk 'gsub(/\./,"") {printf "WLAN_QLT=%s;", $3}')
#	eval $(cat ${PROC_WIFI} | awk 'gsub(/\./,"") {printf "WLAN_SIG=%s;", $4}')
#	eval $(cat ${PROC_WIFI} | awk 'gsub(/\./,"") {printf "WLAN_NS=%s;", $5}')
#	BCSCRIPT="scale=0;a=100*$WLAN_QLT/70;print a"
#	WLAN_QPC=`echo $BCSCRIPT | bc -l`
#	POWER=`${IWCONFIG} 2>/dev/null | awk -F= '/Tx-Power/ {print "Tx="$3}'`
#	RATE=`${IWCONFIG} 2>/dev/null | awk -F'[=|Tx]' '/Bit/ {print "Rate="$2}'`
#	WLAN_OUT="$ESSID Q=${WLAN_QPC}% S/N=${WLAN_SIG}/${WLAN_NS} ${RATE}${POWER}"
#}


##WIFI
wifi() {
	wist=`grep "^\s*w" /proc/net/wireless | awk '{ print int($3 * 100 / 70) "%" }'`
	echo -e "WIFI: $wist"
}


## VOLUME
#vol() {
#	 vol=`amixer get Master | awk -F'[][]' 'END{ print $4":"$2 }' | sed 's/on://g'`
#	 echo -e "VOL: $vol"
#}

SLEEP_SEC=3
#loops forever outputting a line every SLEEP_SEC secs


# It seems that we are limited to how many characters can be displayed via
# the baraction script output. And the the markup tags count in that limit.
# So I would love to add more functions to this script but it makes the 
# echo output too long to display correctly.
while :; do
	echo "+@fg=4; $(hdd) +@fg=0; | +@fg=2; $(mem) +@fg=0; | +@fg=7; $(cpu) +@fg=0; | $(wifi) +@fg=0; | +@fg=8; $(dte) +@fg=0; |"
	sleep $SLEEP_SEC
done

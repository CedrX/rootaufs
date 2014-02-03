#!/bin/sh


add_iptables() {
	ip_addr=$1
	port=$2
	/sbin/iptables -t nat -A PREROUTING -m tcp -p tcp --dport $port -j DNAT --to-destination $ip_addr:$port
	logger "/sbin/iptables -t nat -A PREROUTING -m tcp -p tcp --dport $port -j DNAT --to-destination $ip_addr:$port"
	/sbin/iptables -t nat -A PREROUTING -m udp -p udp --dport $port -j DNAT --to-destination $ip_addr:$port
	logger "/sbin/iptables -t nat -A PREROUTING -m udp -p udp --dport $port -j DNAT --to-destination $ip_addr:$port"
}

del_iptables() {
	ip_addr=$1
	lineNumbers=$(/sbin/iptables -t nat -L PREROUTING -v -n --line-numbers | grep "to:$ip_addr:" | cut -d ' ' -f 1 | sort -r)
	for i in $lineNumbers ; do 
		/sbin/iptables -t nat -D PREROUTING $i
		logger "/sbin/iptables -t nat -D PREROUTING $i"
	done
}

Usage() {
	logger "Usage : $0 action mac_addr ip_addr hostname"
	exit 1
}

logger "USER : $USER"
logger "[dnsmasq] dhcpscript nombre d'arguments: $#"
logger "[dnsmasq] dhcpscript arguments: $@"
logger "Variable DNSMASQ_VENDOR_CLASS: $DNSMASQ_VENDOR_CLASS"
logger "Variable DNSMASQ_CLIENT_ID: $DNSMASQ_CLIENT_ID"
logger "Variable DNSMASQ_TAGS : $DNSMASQ_TAGS"
logger "\$1 : $1"

case "$1" in
	"add")
		for i in $(echo $DNSMASQ_VENDOR_CLASS | sed 's/:/ /g') ; do 
			add_iptables $3 $i
		done
		;;
	"old")
		logger "je passe dans le cas old"
		logger "Appel de del_iptables $3"
		del_iptables $3
                for i in $(echo $DNSMASQ_VENDOR_CLASS | sed 's/:/ /g') ; do
                        add_iptables $3 $i
                done
		;;
	"del")
		del_iptables $3
		;;
	*)	Usage
		;;
esac
		
	

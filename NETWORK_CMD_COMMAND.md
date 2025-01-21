# ipconfig

get ip address

     $ ipconfig getifaddr en0
     $ ip=`ipconfig getifaddr en0`; echo $ip
     192.168.1.154

get subnet mask

     $ ipconfig getoption en0 subnet_mask
     255.255.255.0

get dns server

     $ ipconfig getoption en0 domain_name_server
     192.168.1.253

get info about how en0 got its dhcp on

     $ ipconfig getpacket en0
     op = BOOTREPLY
     htype = 1
     flags = 0
     hlen = 6
     hops = 0
     xid = 765413854
     secs = 0
     ciaddr = 192.168.1.154
     yiaddr = 192.168.1.154
     siaddr = 0.0.0.0
     giaddr = 0.0.0.0
     chaddr = 34:36:3b:cd:fd:ae
     sname =
     file =
     options:
     Options count is 7
     dhcp_message_type (uint8): ACK 0x5
     server_identifier (ip): 192.168.1.253
     lease_time (uint32): 0x1c20
     subnet_mask (ip): 255.255.255.0
     router (ip_mult): {192.168.1.253}
     domain_name_server (ip_mult): {192.168.1.253}
     end (none):

renew dhcp lease

     ipconfig set en0 DHCP

set a specific ip address

     ipconfig set en0 INFORM 192.168.1.160

# ifconfig

get network info

     $ ifconfig en0
     en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
         ether 34:36:3b:cd:fd:ae
         inet6 fe80::3636:3bff:fecd:fdae%en0 prefixlen 64 scopeid 0x4
         inet 192.168.1.154 netmask 0xffffff00 broadcast 192.168.1.255
         nd6 options=1<PERFORMNUD>
         media: autoselect
         status: active

set ip address and netmask

     ifconfig en0 inet 192.168.1.154 netmask 255.255.255.0

renew dhcp leases

     ipconfig set en0 BOOTP && ipconfig set en0 DHCP
     ifconfig en0 down && ifconfig en0 up

# networksetup

get a list of location on the computer

     $ networksetup -listlocations
     Automatic

get active location

     $ networksetup -getcurrentlocation
     Automatic

config manual static ip address

     networksetup -setmanual Wi-Fi 192.168.1.154 255.255.255.0 192.168.1.253

config dns server

     networksetup -setdnsservers Wi-Fi 192.168.1.154 192.168.1.253

get dns server

     networksetup -getdnsservers Wi-Fi

# firewall

stop the application layer firewall

     launchctl unload /System/Library/LaunchAgents/com.apple.alf.useragent.plistlaunchctl unload /System/Library/LaunchAgents/com.apple.alf.agent.plist

start the application layer firewall

     launchctl load /System/Library/LaunchAgents/com.apple.alf.agent.plistlaunchctl load /System/Library/LaunchAgents/com.apple.alf.useragent.plist

allow an app to communicate outside through the application layer firewall

     socketfilterfw -t "/Applications/..."

# route

routing table

     netstat -nr

add a route

     # so that traffice for 192.168.1.0/24
     # communicates over the 192.168.1.253
     $ sudo route -n add 192.168.1.0/24 192.168.1.253

delete a route

     sudo route -n delete 192.168.1.0/24 192.168.1.253

# netstat

view info on all sockets

     netstat -at

network info for ipv6

     netstat -lt

per protocol network statistics

     netstat -s

statistics for a specific network protocol

     netstat -p igmp

statistics for network interfaces

     netstat -i

view network info as it happens

     ntop

# ping

put a delay in pings

     ping -i 5 192.168.1.253

ping hostname 5 times and then stop

     ping -c 5 192.168.1.253

flood ping the host

     ping -f location

set packet size during ping

     ping -s 100 192.168.1.253

customize source ip during ping

     ping -S 192.168.1.160 192.168.1.253

# trace

trace the path packets go through

     traceroute baidu.com

without looking up names

     traceroute -n baidu.com

in debug mode

     traceroute -d baidu.com

# nc

establish a network connection

     nc -v baidu.com 80

establish a network connection over port 2195

     nc -v -w 15 baidu.com 2196

establish a network connection only allowing ipv4

     nc -v -4 baidu.com 2196

setup a network listener on port 2196 for testing

     nc -l 2196

# tcpdump

capture some packets

     tcpdump -nS

capture all packets

     tcpdump-nnvvXS

capture packets for port

     tcpdump -nnvvXs 548

capture all packets for a given port going to destination 192.168.1.160

     tcpdump -nnvvXs 548 dst 192.168.1.160

capture packets as above but dump to a pcap file

     tcpdump -nnvvXs 548 dst 192.168.1.160 -w /tmp/demo.pcap

read tcpdump (cap) files and make them human readable

     tcpdump -qns 0 -A -r /tmp/demo.pcap

# other

flush the dns cache

     dscacheutil -flushcache

clear arp cache

     arp -ad

what binaries have what ports and in what states are those ports

     lsof -n -i4TCP

make an alias for looking at what has a listener open, called ports

     alias ports='lsof -n -i4TCP | grep LISTEN'

edit hosts file

     sudo pico /private/etc/hosts

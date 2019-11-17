#!/bin/sh
echo "starting container and tcpdump"
cont_id=$(sudo docker run -d -p 23:23/tcp  busydocker:latest)
sudo tshark -i docker0  -w /tmp/telnet.pcap &
echo "done"

while [ 1 ]
do
    if [ -f /tmp/do_reset ]
    then
        echo "done prediction. killing container and tcpdump"
        sudo killall -15 tshark
        sudo docker stop $cont_id
        sudo rm /tmp/stream*.pcap
        rm /tmp/do_reset
        cont_id=$(sudo docker run -d -p 23:23/tcp busydocker:latest)
        sudo tshark -i docker0  -w /tmp/telnet.pcap &
        echo "done"
    elif [ -f /tmp/do_remove ]
    then
        echo "removing non malware traffic pcap"
        sudo rm /tmp/stream*.pcap
    fi

    if ( sudo tshark -r /tmp/telnet.pcap -T fields -e tcp.dstport -e ip.proto  -e tcp.stream  | grep -q "^23" )
    then
        echo "found attack. downloading..."
        stream=$(sudo tshark -r /tmp/telnet.pcap -T fields -e tcp.dstport -e ip.proto  -e tcp.stream  | grep "^23"  | head -n1 | awk '{print $3}')
        echo "attack stream:$stream"
        sudo tshark -r /tmp/telnet.pcap -Y "tcp.stream==$stream" | head -n 5
        now=$(date +"%H_%M_%S_%m_%d_%Y")
        sudo tshark -r /tmp/telnet.pcap -Y "tcp.stream==$stream" -w /tmp/stream_${stream}_date_${now}.pcap
        sudo killall -15 tshark
        #sudo mv /tmp/telnet.pcap /tmp/telnet_date_${now}.pcap
        sudo tshark -i docker0  -w /tmp/telnet.pcap &
    else
        echo -n "."
    fi
    sleep 10
done

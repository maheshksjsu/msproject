#!/bin/sh
cont_ip="172.17.0.2"
if [ $2 -eq 1 ]; then
	field="tcp.flags.syn"
elif [ $2 -eq 2 ]; then
	field="tcp.flags.fin"
elif [ $2 -eq 3 ]; then
	field="tcp.len"
elif [ $2 -eq 4 ]; then
	field="tcp.dstport"
elif [ $2 -eq 5 ]; then
	field="ip.proto"
fi
out=$(tshark -r $1 -T fields  -e $field ip.dst==$cont_ip)
sum=0
count=0
for i in $out
do
	sum=$(expr $sum + $i)
	count=$(expr $count + 1)
done
if [ $count -gt 0 ]
then
	avg=$(echo 2k $sum $count /p | dc)
else
	avg=0
fi
#echo "sum=$sum"
#echo "len=${count}"
#echo "avg=$avg"
echo -n "$avg"

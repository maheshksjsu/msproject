#!/bin/sh
in_file=$1
out_file=$2
syn_avg=$(./dump.sh $in_file 1)
fin_avg=$(./dump.sh $in_file 2)
len_avg=$(./dump.sh $in_file 3)
dport=$(./dump.sh $in_file 4)
proto=$(./dump.sh $in_file 5)
echo "$in_file,$syn_avg,$fin_avg,$len_avg,$dport,$proto" >> $out_file

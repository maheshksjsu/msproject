
out_file=predict_dataset.csv
scp -i aws-keys.pem ubuntu@ec2-3-16-53-88.us-east-2.compute.amazonaws.com:/tmp/stream*.pcap . 2>/dev/null
if [ $? -eq 0 ]
then
	echo "Stream,SYN,FIN,LEN,DPORT,PROTO" > $out_file
	for i in `ls stream*.pcap`
	do
		echo "processing $i"
		./dumpall.sh $i $out_file
		echo "moving $i to processed folder"
		mv $i processed/
	done
else
	echo "no files"
fi

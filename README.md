# msproject - Analysis of Mirai malware and its variants.

This project uses SVM model to predict a network traffic(pcap) as MIRAI malware variant or not.
It learns from the dataset(dataset.csv), then periodically download the pcap files from an AWS host where a docker honeypot with open telnet port is setup. This attracts the mirai malwares. The traffic onto AWS host is downloaded periodically to localhost where svm runs and fed to svm to predict.

Installation
-----------
1. copy the honeypot directory to AWS VM and run ./capture.sh
2. copy the svm directory to a local host and run the svm.py

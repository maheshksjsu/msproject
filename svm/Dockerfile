FROM ubuntu:18.04

RUN apt update
RUN apt -y install tshark openssh-client dc tcpick python3 python3-pip
RUN pip3 -y install numpy sklearn matplotlib pandas 
COPY *.sh /
COPY *.py /
RUN mkdir -p /root/.ssh /processed
COPY config /root/.ssh/
COPY aws-keys.pem /root
RUN chmod 600 /root/aws-keys.pem

CMD python3 /svm.py

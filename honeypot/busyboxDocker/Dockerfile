FROM busybox
RUN echo "root:root" | chpasswd 
RUN adduser -D -g '' telnetadmin 
RUN adduser -D -g '' e8ehome 
RUN adduser -D -g '' admin
RUN adduser -D -g '' default
RUN echo "telnetadmin:telnetadmin" | chpasswd 
RUN echo "e8ehome:e8ehome " | chpasswd 
RUN echo "admin:admin123" | chpasswd 
RUN echo "default:default" | chpasswd 
COPY startup.sh /
RUN chmod +x /startup.sh
CMD [ "/startup.sh"]


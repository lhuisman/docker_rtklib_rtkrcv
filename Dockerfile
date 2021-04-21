# Using alpine
FROM alpine as builder

# Installing required packages
RUN \
  apk add build-base

# Create folder for source codes
RUN mkdir /root/src \
  && mkdir /data

# Copy and compile str2str and convbin (RTKLIB)
COPY RTKLIB /root/src/rtklib

RUN cd /root/src/rtklib/app/consapp/rtkrcv/gcc \
  && make \
  && make install \
  && cd

# Make the binaries executable
RUN chmod +x /usr/local/bin/*

# Using alpine
FROM alpine as application

# Copy scripts 
COPY root /root/

# Make the binaries executable
# Configure crontab
RUN chmod +x /root/bin/*
# Copy compiled binaries
COPY --from=builder /usr/local/bin/rtkrcv /usr/local/bin/

# Start main script (crond and rtkrcv)
CMD ["/root/bin/doall"]    

FROM alpine:latest
RUN apk update
RUN apk upgrade
RUN apk add --no-cache ca-certificates

MAINTAINER Deanosim 4834976+Deanosim@users.noreply.github.com

# Extras
RUN apk add --no-cache curl

# Timezone (TZ)
RUN apk update && apk add --no-cache tzdata
ENV TZ=Australia/Melbourne
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add Bash shell & dependancies
RUN apk add --no-cache bash busybox-suid su-exec

# Volumes
VOLUME /config
VOLUME /root/.xteve
VOLUME /tmp/xteve

# Add ffmpeg and vlc
RUN apk add ffmpeg
RUN apk add vlc
RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc

# Add xTeve and guide2go
RUN wget https://github.com/SCP002/xTeVe/releases/download/2.4.1.0000/xteve_linux_amd64 -O xteve; cp xteve /usr/bin/; rm xteve
ADD cronjob.sh /
ADD entrypoint.sh /
ADD sample_cron.txt /
ADD sample_xteve.txt /

# Set executable permissions
RUN chmod +x /entrypoint.sh
RUN chmod +x /cronjob.sh
RUN chmod +x /usr/bin/xteve

# Expose Port
EXPOSE 34400

# Entrypoint
ENTRYPOINT ["./entrypoint.sh"]

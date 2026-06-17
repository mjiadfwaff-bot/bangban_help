FROM alpine:3.23

###############################################################################
#                                INSTALLATION
###############################################################################

ENV WORKDIR                 /app
RUN printf '%s\n' \
        'https://dl-cdn.alpinelinux.org/alpine/v3.23/main' \
        'https://dl-cdn.alpinelinux.org/alpine/v3.23/community' \
        > /etc/apk/repositories \
    && apk add --no-cache bash ca-certificates tzdata ffmpeg
ADD hack                $WORKDIR/hack/
ADD manifest/config                $WORKDIR/manifest/config/
ADD resource                $WORKDIR/resource/
ADD ./temp/hotgo $WORKDIR/hotgo
ADD ./manifest/docker/entrypoint.sh $WORKDIR/entrypoint.sh
RUN chmod +x $WORKDIR/hotgo
RUN chmod +x $WORKDIR/entrypoint.sh


###############################################################################
#                                   START
###############################################################################

WORKDIR $WORKDIR
CMD ./entrypoint.sh

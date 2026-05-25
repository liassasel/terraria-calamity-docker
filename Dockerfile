# Dockerfile para DaemonOS tModLoader
FROM steamcmd/steamcmd:alpine-3

RUN apk update \
    && apk add --no-cache bash curl tmux libstdc++ libgcc icu-libs unzip dos2unix \
    && rm -rf /var/cache/apk/*

RUN mkdir /steamlib \
    && mv /lib/libstdc++.so.6 /steamlib \
    && mv /lib/libgcc_s.so.1 /steamlib
ENV LD_LIBRARY_PATH=/steamlib

ARG UID=1000
ARG GID=1000
RUN addgroup -g $GID tml \
    && adduser -D -u $UID -G tml -h /home/tml tml

ENV USER=tml
ENV HOME=/home/tml
ENV TML_DIR=/home/tml/.local/share/Terraria/tModLoader
ENV SCRIPTS_PATH=$TML_DIR/Scripts
ENV PATH="${SCRIPTS_PATH}:${PATH}"

RUN mkdir -p /data && chown tml:tml /data \
    && mkdir -p $TML_DIR \
    && chown -R tml:tml $HOME

USER tml
WORKDIR $HOME

COPY --chown=tml:tml manage-tModLoaderServer.sh .
COPY --chown=tml:tml entrypoint.sh .
RUN dos2unix manage-tModLoaderServer.sh entrypoint.sh \
    && chmod +x manage-tModLoaderServer.sh entrypoint.sh

ARG TML_VERSION="v2023.06.25.36" # Pon la versión que suelas usar por defecto
RUN ./manage-tModLoaderServer.sh install-tml --github --tml-version $TML_VERSION

EXPOSE 7777

ENTRYPOINT [ "./entrypoint.sh" ]
FROM ibm-semeru-runtimes:open-23-jre

LABEL maintainer Delnegend <kiennguyen19323@gmail.com>

ARG HATH_VERSION

RUN apt-get update && \
    apt-get install -y ca-certificates tzdata && \
    update-ca-certificates

RUN apt-get install -y --no-install-recommends wget unzip && \
    wget -O /tmp/hath-$HATH_VERSION.zip https://repo.e-hentai.org/hath/HentaiAtHome_$HATH_VERSION.zip && \
    mkdir -p /opt/hath /hath && \
    unzip /tmp/hath-$HATH_VERSION.zip -d /opt/hath && \
    rm /tmp/hath-$HATH_VERSION.zip && \
    apt-get remove -y wget unzip && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ADD run/* /opt/hath/

RUN chmod +x /opt/hath/*.sh

VOLUME ["/hath/cache", "/hath/data", "/hath/download", "/hath/log", "/hath/tmp"]

CMD ["/opt/hath/start.sh"]
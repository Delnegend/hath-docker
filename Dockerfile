FROM alpine:latest AS builder

ARG HATH_VERSION

RUN apk add --no-cache unzip wget

RUN wget -O /tmp/hath-$HATH_VERSION.zip https://repo.e-hentai.org/hath/HentaiAtHome_$HATH_VERSION.zip && \
    mkdir -p /hath_extracted && \
    unzip /tmp/hath-$HATH_VERSION.zip -d /hath_extracted

FROM ibm-semeru-runtimes:open-25-jre

LABEL maintainer="Delnegend <kiennguyen19323@gmail.com>"

COPY --from=builder /hath_extracted/ /opt/hath/
COPY start.sh /opt/hath/

RUN apt-get update && \
    apt-get install -y ca-certificates tzdata && \
    apt-get autoremove -y && \
    update-ca-certificates && \
    chmod +x /opt/hath/*.sh && \
    mkdir -p /hath/cache /hath/data /hath/download /hath/log /hath/tmp && \
    chown -R ubuntu:ubuntu /opt/hath /hath

ENTRYPOINT "/opt/hath/start.sh || (echo 'Failing, waiting 30s...' && sleep 30s && exit 1)"
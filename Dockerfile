FROM eclipse-temurin:22-jre

ENV TZ=Asia/Shanghai
WORKDIR /opt/qread

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl unzip \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/qread \
    && curl -fsSL "https://github.com/autobcb/read/releases/download/3.4.6b3/web3.4.6b3.zip" -o /tmp/read.zip \
    && unzip -q /tmp/read.zip -d /opt/qread \
    && rm -f /tmp/read.zip \
    && if [ ! -f /opt/qread/conf.yml ]; then curl -fsSL "https://raw.githubusercontent.com/autobcb/read/main/conf/conf.yml" -o /opt/qread/conf.yml; fi \
    && test -f /opt/qread/read.jar \
    && test -f /opt/qread/conf.yml

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

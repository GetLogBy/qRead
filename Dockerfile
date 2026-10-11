FROM eclipse-temurin:22-jre

ENV TZ=Asia/Shanghai
WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl unzip \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL "https://github.com/autobcb/read/releases/download/3.4.6b3/web3.4.6b3.zip" -o /tmp/read.zip \
    && unzip -q /tmp/read.zip -d /app \
    && rm -f /tmp/read.zip \
    && if [ ! -f /app/conf.yml ]; then curl -fsSL "https://raw.githubusercontent.com/autobcb/read/main/conf/conf.yml" -o /app/conf.yml; fi \
    && test -f /app/read.jar \
    && test -f /app/conf.yml

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

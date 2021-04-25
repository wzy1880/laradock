FROM golang:1.7.1-alpine

# If you're in China, or you need to change sources, will be set CHANGE_SOURCE to true in .env.
ARG CHANGE_SOURCE=false
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # echo "185.199.108.133 raw.githubusercontent.com" >> /etc/hosts \
    #echo "162.125.1.8 github.global.ssl.fastly.net" >> /etc/hosts \
    # Change application source from dl-cdn.alpinelinux.org to aliyun source
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
;fi

ADD build.sh /
RUN apk add --no-cache git make openssl
RUN git clone https://github.com/inconshreveable/ngrok.git --depth=1 /ngrok
RUN sh /build.sh
EXPOSE 8081
VOLUME [ "/ngrok" ]
CMD [ "sh", "-c", "/ngrok/bin/ngrokd  -domain ${NGROK_DOMAIN} -httpAddr=:8081"]

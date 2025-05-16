FROM alpine:latest

RUN apk update && apk add msmtp ca-certificates wget sed gettext

WORKDIR /app

COPY msmtprc.template email.template main.sh ./
RUN chmod +x main.sh

ENTRYPOINT ["./main.sh"]

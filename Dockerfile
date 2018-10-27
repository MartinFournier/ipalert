FROM alpine:latest

RUN apk update && apk add ssmtp

CMD mkdir -p /app
WORKDIR /app
ADD email.template email.template
ADD main.sh main.sh
RUN chmod u+x main.sh

ENTRYPOINT ["./main.sh"]

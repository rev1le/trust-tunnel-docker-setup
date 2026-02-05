FROM ubuntu:latest

WORKDIR /app

RUN apt update && apt install tar

RUN mkdir -p /app/configs
RUN mkdir -p /app/trusttunnel

COPY ./trusttunnel-v0.9.125-linux-x86_64.tar.gz /app/trusttunnel-v0.9.125-linux-x86_64.tar.gz

RUN tar -xzf /app/trusttunnel-v0.9.125-linux-x86_64.tar.gz -C /app/trusttunnel --strip-components=1

CMD ["tail", "-f" ,"/dev/null"]

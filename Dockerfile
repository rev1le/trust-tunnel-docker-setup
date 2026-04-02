FROM ubuntu:latest

WORKDIR /app

RUN apt update && apt install tar

RUN mkdir -p /app/configs
RUN mkdir -p /app/trusttunnel

COPY ./trusttunnel-v1.0.29-linux-x86_64.tar.gz /app/trusttunnel-linux-x86_64.tar.gz

RUN tar -xzf /app/trusttunnel-linux-x86_64.tar.gz -C /app/trusttunnel --strip-components=1

RUN chmod +x  /app/trusttunnel/trusttunnel_endpoint

CMD ["tail", "-f" ,"/dev/null"]

FROM eclipse-eclipse-temurin:21-jre

EXPOSE 25565/tcp
EXPOSE 8100/tcp
EXPOSE 8080/tcp

ENV NEOFORGE_VERSION 21.4.119-beta
ENV MC_EULA true
ENV MC_RAM_XMS 1536M
ENV MC_RAM_XMX 2048M

VOLUME /home/server

USER root
WORKDIR /home/server

COPY src/main.sh /main.sh

RUN apt update &&\
    apt install -y curl findutils unar &&\
    rm -rf /var/lib/apt/lists/*

RUN chmod +x /main.sh

RUN useradd neoforge
USER neoforge

CMD ["/main.sh"]

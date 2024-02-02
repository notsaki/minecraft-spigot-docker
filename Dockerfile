FROM debian:stable
LABEL authors=tsaki

ARG REV=latest
ARG SERVER_OPTIONS="-Xmx1G -Xms1G"

RUN apt-get update \
    && apt-get install -y wget git screen openjdk-17-jdk

RUN mkdir -p /opt/build-tools \
    mkdir -p /opt/minecraft-server

WORKDIR /opt/build-tools

RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O /opt/build-tools/BuildTools.jar \
    && java -jar /opt/build-tools/BuildTools.jar --rev $REV

WORKDIR /opt

RUN mv ./build-tools/spigot*.jar ./minecraft-server/server.jar
RUN echo "eula=true" > ./minecraft-server/eula.txt
RUN echo "screen -d -m \"java $SERVER_OPTIONS -jar server.jar\"" > ./minecraft-server/start.sh

RUN apt-get remove -y wget git

WORKDIR /opt/minecraft-server

EXPOSE 25565
EXPOSE 25565/udp
VOLUME /opt/minecraft-server
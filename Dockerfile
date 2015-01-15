FROM jeanblanchard/busybox-java:8

MAINTAINER Kamil Manka <kamil.manka@gmail.com>

ENV NEXUS_VERSION 2.11.1-01
ENV NEXUS_NAME nexus-$NEXUS_VERSION
ENV NEXUS_ARCHIVE $NEXUS_NAME-bundle.tar.gz

RUN mkdir -p /opt/lib/nexus
ADD nexus_run.sh /opt/lib/nexus/

ENV NEXUS_HOME /opt/lib/nexus/$NEXUS_NAME

RUN echo $NEXUS_HOME
RUN curl -s -k https://download.sonatype.com/nexus/oss/$NEXUS_ARCHIVE | gzip -cdq | tar xf - -C /opt/lib/nexus
RUN rm -rf /tmp/*

RUN adduser -h /opt/lib/nexus -S nexus
RUN chown nexus:nexus -R /opt/lib/nexus

WORKDIR /opt/lib/nexus
RUN chmod +rx nexus_run.sh

USER nexus
RUN sed -i "s,nexus-webapp-context-path=/nexus,nexus-webapp-context-path=/,g" $NEXUS_HOME/conf/nexus.properties

EXPOSE 8081

VOLUME ["/opt/lib/nexus/sonatype-work"]

CMD ["./nexus_run.sh"]
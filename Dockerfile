FROM jeanblanchard/busybox-java:8

MAINTAINER Kamil Manka <kamil.manka@gmail.com>

ENV NEXUS_VERSION 2.11.1-01
ENV NEXUS_NAME nexus-$NEXUS_VERSION
ENV NEXUS_ARCHIVE $NEXUS_NAME-bundle.tar.gz
ENV HOME /opt/lib/nexus
ENV NEXUS_HOME $HOME/$NEXUS_NAME
ENV NEXUS_WORK $HOME/sonatype-work

RUN mkdir -p $HOME
ADD nexus_run.sh $HOME/
RUN chmod +rx $HOME/nexus_run.sh


RUN curl -s -k https://download.sonatype.com/nexus/oss/$NEXUS_ARCHIVE | gzip -cdq | tar xf - -C $HOME

RUN adduser -h $HOME -S nexus
RUN chown nexus:nexus -R $HOME

# This must be a regular path, do not use variables
WORKDIR /opt/lib/nexus

USER nexus
RUN sed -i "s,nexus-webapp-context-path=/nexus,nexus-webapp-context-path=/,g" $NEXUS_HOME/conf/nexus.properties

EXPOSE 8081

VOLUME ["/opt/lib/nexus/sonatype-work"]

CMD ["./nexus_run.sh"]
#!/bin/sh

if [ ! -d $NEXUS_WORK/nexus ]; then
	su -c 'chown nexus:nexus -R $NEXUS_WORK';
	mkdir -p $NEXUS_WORK/nexus;
fi

exec $NEXUS_HOME/bin/nexus console
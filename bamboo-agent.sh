#!/bin/bash

cd ~

if [ -z "${BAMBOO_SERVER}" ]; then
	echo "Bamboo server URL undefined!" >&2
	echo "Please set BAMBOO_SERVER environment variable to URL of your Bamboo instance." >&2
	exit 1
fi

BAMBOO_VERSION=`wget -O- ${BAMBOO_SERVER} 2>/dev/null | sed -n 's/^.*version \([0-9.]\+\) build.*/\1/p'`
BAMBOO_AGENT=atlassian-bamboo-agent-installer-${BAMBOO_VERSION}.jar

if [ ! -f ${BAMBOO_AGENT} ]; then
	wget "-O${BAMBOO_AGENT}" "${BAMBOO_SERVER}/agentServer/agentInstaller/${BAMBOO_AGENT}"
fi

Xvfb &

java -jar "${BAMBOO_AGENT}" "${BAMBOO_SERVER}/agentServer/"

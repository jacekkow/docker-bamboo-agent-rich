#!/bin/bash

cd ~

if [ -z "${BAMBOO_SERVER}" ]; then
	echo "Bamboo server URL undefined!" >&2
	echo "Please set BAMBOO_SERVER environment variable to URL of your Bamboo instance." >&2
	exit 1
fi

BAMBOO_AGENT=atlassian-bamboo-agent-installer.jar

if [ ! -f ${BAMBOO_AGENT} ]; then
	wget "-O${BAMBOO_AGENT}" "${BAMBOO_SERVER}/agentServer/agentInstaller/${BAMBOO_AGENT}"
fi

export DISPLAY=:1

rm -f /tmp/Xvfb.log
( while true; do Xvfb :1 >> /tmp/Xvfb.log 2>&1; rm -f /tmp/.X1-lock; done ) &

java -jar "${BAMBOO_AGENT}" "${BAMBOO_SERVER}/agentServer/"

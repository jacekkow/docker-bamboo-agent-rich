FROM centos:7
MAINTAINER Jacek Kowalski <jkowalsk@student.agh.edu.pl>

# Gradle version to install
ENV GRADLE_INSTALL_VERSION 2.3

# Update system & install dependencies
RUN yum -y update \
	&& yum -y install cvs subversion git mercurial java-1.7.0-openjdk-devel java-1.8.0-openjdk-devel ant maven unzip wget xorg-x11-server-Xvfb \
	&& yum -y clean all

# Install gradle
RUN cd /tmp \
	&& wget "https://services.gradle.org/distributions/gradle-${GRADLE_INSTALL_VERSION}-bin.zip" \
	&& unzip gradle-${GRADLE_INSTALL_VERSION}-bin.zip -d /opt \
	&& rm gradle-${GRADLE_INSTALL_VERSION}-bin.zip

# Install Oracle JDK
RUN wget --no-check-certificate --no-cookies \
	--header "Cookie: oraclelicense=accept-securebackup-cookie" \
	http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm \
	&& yum -y localinstall jdk-8u45-linux-x64.rpm \
	&& rm -f jdk-8u45-linux-x64.rpm

# Install node.js
RUN yum -y install epel-release \
	&& yum -y install nodejs

RUN useradd -r -m -U bamboo-agent

COPY bamboo-agent.sh /

USER bamboo-agent
CMD ["/bamboo-agent.sh"]

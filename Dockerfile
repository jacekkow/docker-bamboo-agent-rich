FROM centos:7
MAINTAINER Jacek Kowalski <jkowalsk@student.agh.edu.pl>

# Maven version to install
ENV MAVEN_INSTALL_VERSION 3.3.9
# Gradle version to install
ENV GRADLE_INSTALL_VERSION 2.3

# Update system & install dependencies
RUN yum -y update \
	&& yum -y install cvs subversion git mercurial java-1.7.0-openjdk-devel java-1.8.0-openjdk-devel ant unzip wget which xorg-x11-server-Xvfb \
	&& yum -y clean all

# Install maven (see https://jira.atlassian.com/browse/BAM-16043)
RUN cd /tmp \
	&& wget ftp://mirror.reverse.net/pub/apache/maven/maven-3/${MAVEN_INSTALL_VERSION}/binaries/apache-maven-${MAVEN_INSTALL_VERSION}-bin.tar.gz \
	&& tar xf apache-maven-${MAVEN_INSTALL_VERSION}-bin.tar.gz -C /opt \
	&& rm -f apache-maven-${MAVEN_INSTALL_VERSION}-bin.tar.gz

# Install gradle
RUN cd /tmp \
	&& wget "https://services.gradle.org/distributions/gradle-${GRADLE_INSTALL_VERSION}-bin.zip" \
	&& unzip gradle-${GRADLE_INSTALL_VERSION}-bin.zip -d /opt \
	&& rm gradle-${GRADLE_INSTALL_VERSION}-bin.zip

RUN useradd -r -m -U bamboo-agent

COPY bamboo-agent.sh /

USER bamboo-agent
CMD ["/bamboo-agent.sh"]

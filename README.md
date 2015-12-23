This is Docker image of a remote agent for Atlassian Bamboo,
customized for building Java, Gradle and SWT-based applications.

It is not based on Atlassian image - instead it is built
from bare CentOS 7 image.

## Components

This image is based on latest CentOS 7 image from official
Docker repository with additional applications installed:

* version control systems:
 * CVS (/bin/cvs),
 * SVN (/bin/svn),
 * Git (/bin/git),
 * Hg (/bin/hg),
* JDKs:
 * OpenJDK 1.7 (/usr/lib/jvm/java-1.7.0-openjdk),
 * OpenJDK 1.8 (/usr/lib/jvm/java-1.8.0-openjdk),
 * Oracle JDK 1.8 (/usr/java/latest),
* build systems:
 * Ant (/usr/share/ant),
 * Maven 3 (/opt/apache-maven),
 * Gradle 2 (/opt/gradle),
* miscellaneous:
 * JRuby 9k,
 * node.js,
 * Phantom JS 1.9,
 * unzip,
 * wget,
 * Xvfb (started during container initialization).

Apart from Gradle and Maven, all software is installed
from CentOS or EPEL repositories.

Gradle is installed using binary package available
on the official website.

## Usage

Create Docker container and pass URL to your Bamboo installation
using `BAMBOO_SERVER` environment variable:

```bash
docker run -d --name="bamboo-agent1" -e BAMBOO_SERVER=http://bamboo.domain.local jacekkow/bamboo-agent-rich-iisg
```

Remember to approve access for a new remote agent in Bamboo
administration console if "Remote Agent Authentication" is enabled.
See https://confluence.atlassian.com/display/BAMBOO/Agent+authentication
for more information.

It is also possible to fix agent's UUID (e.g. to one already authorized)
using `BAMBOO_AGENT_UUID` environment variable:

```bash
docker run -d --name="bamboo-agent1" -e BAMBOO_AGENT_UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx -e BAMBOO_SERVER=http://bamboo.domain.local jacekkow/bamboo-agent-rich-iisg
```

## Internals

On first run agent JAR is downloaded from URL:
```bash
${BAMBOO_SERVER}/agentServer/agentInstaller/atlassian-bamboo-agent-installer.jar
```

Then Xvfb is started in background. Whenever it fails, it is automatically restarted.
Logs are written to file /tmp/Xvfb.log

Finally JAR downloaded in step 1 is started using default JVM (OpenJDK 1.7).

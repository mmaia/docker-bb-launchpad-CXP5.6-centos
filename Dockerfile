# version 0.1.draft - 
# 
# by mmaia - marcos@backbase.com, maia.marcos@gmail.com
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# This Dockerfile is free to use but it depends on Backbase Portal CXP 5.6 Platform software, 
# which is licensed.
# Visit www.backbase.com

#---- Running this example
#---- Edit the settings.xml and add you Backbase repository username and password(find the following tags in settings.xml)
#----  <username>$REPLACE_WITH_VALID_USERNAME</username>
#----  <password>$REPLACE_WITH_VALID_PASSWORD</password>
#----
#---- Build an image with this Dockerfile to do that navigate with a terminal to the directory where you've checked out
#---- this Dockerfile and type, make sure you have docker installed and available and that you have access to Backbase repository:

#---- docker build -t="bb/bbportal_cxp56:v01" .

#---- the above command will create an image with all required dependencies installed and configured and Backbase portal installed.
#---- Now check if the image was correctly created with the command:
#---- docker images
#---- You should see the image bb/bbportal_cxp56 version v01 created in the image list printed.
#---- Next step is to use the image as a base image to run the container

#---- docker run -i -p 7777:7777 --name bbportal_cxp56 -v /Users/marcos/BackBaseProjects/bb-docker-volume/services:/opt/bbPortalTraining/services bb/bbportal_cxp56:v01

#---- the above command will start the container, now if you want to attach a terminal session inside the container run:

#--- docker exec -it bbportal_cxp56 bash

#--- next time you decide to start this container you can use the start command and after that you can attach with above exec command if desired

#--- docker start bbportal_cxp56



FROM ubuntu:14.04
MAINTAINER Marcos Maia "marcos@backbase.com"

LABEL com.backbase.vendor="Backbase BV" \
version="beta-01" \
description="This is a basic Backbase Portal Server implementation container to be used for training and development pourposes only."

#------ update, install and clean required utility tools
RUN  apt-get update && apt-get install -y \
git \
unzip \
wget \
nodejs \
npm \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

#---- install some global package dependencies with npm
RUN npm install -g \
bower \
grunt-cli \
gulp


#----- download and install jdk 7 from oracle, security cookie makes it a loooong line, deletes the file after installation
WORKDIR /opt
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz" \
&& tar xzf jdk-7u79-linux-x64.tar.gz \
&& rm -rf jdk-7u79-linux-x64.tar.gz

#----- download and install maven, delete binary after installation
RUN wget http://apache.cs.uu.nl/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz \
&& tar xvf apache-maven-3.3.3-bin.tar.gz \
&& rm -rf apache-maven-3.3.3-bin.tar.gz

#--- set the required BB Portal env variables to the container
ENV PATH=$PATH:/opt/apache-maven-3.3.3/bin:/opt/jdk1.7.0_79/bin \
JAVA_HOME=/opt/jdk1.7.0_79 \
MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=256m -XX:+UseConcMarkSweepGC"

#---- updates maven configuration file to include backbase repository to the root user
ADD settings.xml /root/.m2/

#---- updates maven configuration file to include backbase repository to bbportal user that will be created...
ADD settings.xml /home/bbportal/.m2/

WORKDIR /home/bbportal/.m2

RUN mkdir repository

WORKDIR /opt

RUN mvn archetype:generate -DarchetypeGroupId=com.backbase.launchpad -DarchetypeArtifactId=launchpad-archetype-CXP5.6 \
-DarchetypeVersion=1.1.0 -DgroupId=com.bbportal.training -DartifactId=bbPortalTraining -Dversion=1.0 \
-Dpackage=com.bbportal.training -Dlaunchpad-version=0.13.1 -Dlaunchpad-edition=universal

#---- making sure permissions are ok
RUN chmod -R 755 /opt

#--- creates user and group O.S
RUN groupadd -r bbportal
RUN useradd -g bbportal -d /home/bbportal -m -p bbportal -c "Backbase portal user" -r bbportal
RUN chown -R bbportal:bbportal /home/bbportal
RUN chmod -R 755 /home/bbportal
RUN chown -R bbportal:bbportal /opt/bbPortalTraining

WORKDIR /opt/bbPortalTraining

# change container user to be bbportal from now on...
USER bbportal

RUN mvn clean install -Pclean-database
#RUN mvn clean install -Dnpm-install -Pclean-database

#----- expose portal port, cms port,
EXPOSE 7777 8080

#---- define mount points in image that can be mapped to external file system when necessary
#VOLUME ["/opt/bbPortalTraining/services"]

#---- this is a workaround to make sure the contents of services folder that will be mapped as a volume will not overlay
# the files inside it and they will be present before the next command...
# //TODO - find a solution to fix this problem with the mapped services folder. What happens is that once we do the
# //TODO - volume mapping on the run commmand, the host os filesystem overlays the services folder and the files in it
# //TODO - are not available.

#--- start the portal when container starts
# CMD ["sh", "/opt/bbPortalTraining/webapps/portalserver/run.sh", "-b"]
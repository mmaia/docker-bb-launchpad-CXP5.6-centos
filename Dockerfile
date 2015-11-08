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


FROM centos:7
MAINTAINER Marcos Maia "marcos@backbase.com"

#------ update and clean and install required utility tools
RUN yum -y update && yum clean all && yum install -y unzip && yum install -y wget

#----- install jdk 7 from oracle
RUN cd /opt/ && wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz" && tar xzf jdk-7u79-linux-x64.tar.gz

#----- install maven
RUN cd /opt/ && wget http://apache.cs.uu.nl/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz && tar xvf apache-maven-3.3.3-bin.tar.gz

#----- expose portal port, cms port, 
EXPOSE 7777
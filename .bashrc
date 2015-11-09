# .bashrc

# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

PATH=/opt/apache-maven-3.3.3/bin:/opt/jdk1.7.0_79/bin:$PATH

JAVA_HOME=/opt/jdk1.7.0_79

MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=256m -XX:+UseConcMarkSweepGC"
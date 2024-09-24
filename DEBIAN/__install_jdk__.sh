#!/usr/bin/env bash
##################################################################### This installation assumes you have already downloaded the jdk
# Java is setup in user library
####################################################################
set -e
# create a directory for the jdk in /etc/${services}
mkdir -p /usr/lib/jvm/
# unzip and copy to the new jvm directory
#tar zxvf jdk-11.0.10_linux-x64_bin.tar.gz -C /usr/lib/jvm/
mv -iv jdk-11.0.10 /usr/lib/jvm/
# Tell the system that there's a new JDK version available: 
update-alternatives --install "/usr/bin/java" "java" \
"/usr/lib/jvm/jdk-11.0.10/bin/java" 1
# Set the new JDK as the default:
update-alternatives --set java /usr/lib/jvm/jdk-11.0.10/bin/java
# Tell the system that there's a new java compiler available:
update-alternatives --install "/usr/bin/javac" "javac" \
"/usr/lib/jvm/jdk-11.0.10/bin/javac" 1
# Set the new JDK compiler as the default:
update-alternatives --set javac /usr/lib/jvm/jdk-11.0.10/bin/javac
# Verify the version of the JRE or JDK:
printf "\n\n"
java -version
printf "\n\n"
javac -version
# Setting the JAVA_HOME Environment Variable
cat >>/etc/environment<<EOF
JAVA_HOME="/usr/lib/jvm/jdk-11.0.10"
EOF
# reload the environment file
source /etc/environment
# Verify that the environment variable is set:
echo $JAVA_HOME
printf "\nInstallation Complete......\n"
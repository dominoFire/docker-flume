FROM ubuntu:16.04

# Cache buster
ENV CREATED_AT 2016-05-22T12:30:00
# No interactive sesions
ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen en_US en_US.UTF-8 \
&& dpkg-reconfigure locales

# Note: We use ``&&\`` to run commands one after the other - the ``\``
# allows the RUN command to span multiple lines.
# Install some utilities
# Regenerate locale (language) info
# Instalamos algunas utilerias
RUN apt-get update && apt-get -y install \
      curl \
      wget \
      unzip \
      software-properties-common \
      python-software-properties \
      language-pack-en \
      apt-utils \
      autossh \
      openssh-client \
      openssh-server \
&& rm -rf /var/lib/apt/lists/*


# Default American enlglish language for locales
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV JAVA_HOME /usr/jdk1.8.0_31
ENV FLUME_HOME /opt/apache-flume
ENV HADOOP_HOME /opt/apache-hadoop
ENV PATH $PATH:$JAVA_HOME/bin:$FLUME_HOME/bin:$HADOOP_HOME/bin

## Descargamos Java 8
RUN curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/8u31-b13/server-jre-8u31-linux-x64.tar.gz" \
  | gunzip \
  | tar x -C /usr/ \
  && ln -s $JAVA_HOME /usr/java \
  && rm -rf $JAVA_HOME/man

# Descargamos Apache Hadoop
RUN mkdir -p /opt \
  && cd /opt \
  && curl "http://www-us.apache.org/dist/hadoop/common/hadoop-2.6.4/hadoop-2.6.4.tar.gz" > hadoop-2.6.4.tar.gz \
  && tar -xvf hadoop-2.6.4.tar.gz \
  && mv hadoop-2.6.4 apache-hadoop

# Descargamos Apache Flume
RUN mkdir -p /opt \
  && cd /opt \
  && curl "http://www-us.apache.org/dist/flume/1.6.0/apache-flume-1.6.0-bin.tar.gz" > apache-flume-1.6.0-bin.tar.gz \
  && tar -xvf apache-flume-1.6.0-bin.tar.gz \
  && mv apache-flume-1.6.0-bin apache-flume \
  && mkdir -p $FLUME_HOME/claps

# Volumen para especificar configuraciones
VOLUME /opt/apache-flume/claps
# Carpeta pra configuraciones
VOLUME /opt/apache-flume/conf

# Bajamos las dependencias para usar HDFS en Amazon S3
RUN cd $FLUME_HOME/lib \
  && curl -O -J "http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.2/hadoop-aws-2.7.2.jar" \
  && curl -O -J "http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.11.3/aws-java-sdk-1.11.3.jar" \
  && curl -O -J "http://central.maven.org/maven2/com/amazonaws/aws-java-sdk-core/1.11.3/aws-java-sdk-core-1.11.3.jar" \
  && curl -O -J "http://central.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/1.11.3/aws-java-sdk-s3-1.11.3.jar" \
  && curl -O -J "http://central.maven.org/maven2/com/amazonaws/aws-java-sdk-kms/1.11.3/aws-java-sdk-kms-1.11.3.jar" \
  && cp $HADOOP_HOME/share/hadoop/hdfs/hadoop-hdfs-2.6.4.jar .


ADD entrypoint.sh $FLUME_HOME/

# Que el directorio principal sea donde esta flume
WORKDIR $FLUME_HOME

# Comando
CMD ["/bin/bash", "entrypoint.sh"]

FROM ubuntu:16.04

# Cache buster
ENV CREATED_AT 2016-05-22T16:25:00
# No interactive sesions
ENV DEBIAN_FRONTEND noninteractive
# Regenerate locale (language) info
RUN locale-gen en_US en_US.UTF-8 \
  && dpkg-reconfigure locales

# Note: We use ``&&\`` to run commands one after the other - the ``\``
# allows the RUN command to span multiple lines.

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
ENV MVN_HOME /opt/apache-maven
ENV PATH $PATH:$JAVA_HOME/bin:$FLUME_HOME/bin:$HADOOP_HOME/bin:$MVN_HOME/bin
ENV FLUME_CONF_FILE http.conf

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
  && curl "http://www-us.apache.org/dist/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz" > hadoop-2.7.2.tar.gz \
  && tar -xvf hadoop-2.7.2.tar.gz \
  && mv hadoop-2.7.2 apache-hadoop

# Descargamos Apache Flume
RUN mkdir -p /opt \
  && cd /opt \
  && curl "http://www-us.apache.org/dist/flume/1.6.0/apache-flume-1.6.0-bin.tar.gz" > apache-flume-1.6.0-bin.tar.gz \
  && tar -xvf apache-flume-1.6.0-bin.tar.gz \
  && mv apache-flume-1.6.0-bin apache-flume \
  && mkdir -p $FLUME_HOME/claps

# Descargamos Maven
RUN mkdir -p /opt \
  && cd /opt \
  && curl "http://www-eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz" > apache-maven-3.3.9-bin.tar.gz \
  && tar -xvf apache-maven-3.3.9-bin.tar.gz \
  && mv apache-maven-3.3.9 apache-maven

# Volumen para especificar configuraciones
VOLUME /opt/apache-flume/claps
# Carpeta pra configuraciones
VOLUME /opt/apache-flume/conf

# Bajamos las dependencias para usar HDFS en Amazon S3 via Maven
ADD pom.xml $FLUME_HOME/
RUN cd $FLUME_HOME \
  && mvn process-sources

ADD entrypoint.sh $FLUME_HOME/

# Que el directorio principal sea donde esta flume
WORKDIR $FLUME_HOME

# Comando
CMD ["/bin/bash", "entrypoint.sh"]

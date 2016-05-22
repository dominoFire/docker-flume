# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# If this file is placed at FLUME_CONF_DIR/flume-env.sh, it will be sourced
# during Flume startup.

# Enviroment variables can be set here.

# export JAVA_HOME=/usr/lib/jvm/java-6-sun

# Give Flume more memory and pre-allocate, enable remote monitoring via JMX
# export JAVA_OPTS="-Xms100m -Xmx2000m -Dcom.sun.management.jmxremote"
export AWS_ACCESS_KEY_ID="AKIAJJI6FVVEQLPDT3TQ"
export AWS_SECRET_ACCESS_KEY="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"
export JAVA_OPTS="-Dfs.s3n.awsAccessKeyId=AKIAJJI6FVVEQLPDT3TQ -Dfs.s3n.awsSecretAccessKey=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"

# Note that the Flume conf directory is always included in the classpath.
#FLUME_CLASSPATH=""

HADOOP_HOME=/opt/hadoop-2.6.4
HADOOP_AWS=/opt/hadoop-aws/hadoop-aws-2.7.2.jar
HADOOP_AWS_SDK=/opt/hadoop-aws/aws-java-sdk-1.11.3.jar
HADOOP_AWS_SDK_CORE=/opt/hadoop-aws/aws-java-sdk-core-1.11.3.jar
HADOOP_AWS_SDK_S3=/opt/hadoop-aws/aws-java-sdk-s3-1.11.3.jar
HADOOP_AWS_SDK_KMS=/opt/hadoop-aws/aws-java-sdk-kms-1.11.3.jar

FLUME_CLASSPATH="$HADOOP_AWS:$HADOOP_AWS_SDK:$HADOOP_AWS_SDK_CORE:$HADOOP_AWS_SDK_S3:$HADOOP_AWS_SDK_KMS:$HADOOP_HOME/share/hadoop/hdfs/hadoop-hdfs-2.6.4.jar"

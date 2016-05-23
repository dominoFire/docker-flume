#! /bin/bash

. vars.sh

set -o xtrace

echo "Corriendo imagen Docker $IMAGE_NAME"
docker run \
 -e FLUME_CONF_FILE=kafka.conf \
 -v `readlink -f ./conf`:/opt/apache-flume/conf \
 -v `readlink -f ./claps`:/opt/apache-flume/claps \
 -p 5145:5145 \
 -t $IMAGE_NAME

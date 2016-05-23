#! /bin/bash

set -e 
set -o xtrace

flume-ng agent --conf $FLUME_HOME/conf --conf-file $FLUME_HOME/claps/$FLUME_CONF_FILE --name a1 -Dflume.root.logger=INFO,console

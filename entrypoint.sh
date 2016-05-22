#! /bin/bash

set -e 
set -o xtrace

flume-ng agent --conf $FLUME_HOME/conf --conf-file $FLUME_HOME/claps/http.conf --name a1 -Dflume.root.logger=INFO,console

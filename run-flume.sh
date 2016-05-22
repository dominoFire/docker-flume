#! /bin/bash

set -e 
set -o xtrace

bin/flume-ng agent \
    --conf conf --conf-file claps/http.conf --name a1 \
    -Dflume.root.logger=INFO,console

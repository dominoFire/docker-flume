#! /bin/bash

set -o xtrace

TIME_STAMP="`date +%Y%m%d%H%M%S`"
CONTENT=`echo $TIME_STAMP | md5sum | awk '{print $1}'`

curl -v -XPOST "http://localhost:5145/" -d "[{
  \"headers\": {\"timestamp\":\"$TIME_STAMP\", \"origin\":\"test\"},
  \"body\": \"$CONTENT\"
}]"



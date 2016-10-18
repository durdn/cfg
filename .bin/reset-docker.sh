#!/bin/bash

function col {
  awk -v col=$1 '{print $col}'
}

docker ps -q | xargs docker stop
docker ps -aq | xargs docker rm
docker images | grep none | col 3 | xargs docker rmi -f

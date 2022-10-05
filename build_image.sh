#!/bin/bash

# set variables
_VERSION=1.0.1

# create build
docker build -t johann8/radicale:${_VERSION} .
_BUILD=$?
if ! [ ${_BUILD} = 0 ]; then
   echo "ERROR: Docker Image build was not successful"
   exit 1
else
   echo "Docker Image build successful"
   docker images -a 
   docker tag johann8/radicale:${_VERSION} johann8/radicale:latest
fi

#push image to dockerhub
if [ ${_BUILD} = 0 ]; then
   echo "Pushing docker images to dockerhub..."
   docker push johann8/radicale:latest
   docker push johann8/radicale:${_VERSION}
   _PUSH=$?
   docker images -a |grep radicale
fi

#delete build
if [ ${_PUSH=} = 0 ]; then
   echo "Deleting docker images..."
   docker rmi johann8/radicale:latest
   docker rmi johann8/radicale:${_VERSION}
   docker rmi $(docker images -f "dangling=true" -q)
   docker images -a
fi

# Delete none images
# docker rmi $(docker images --filter "dangling=true" -q --no-trunc)

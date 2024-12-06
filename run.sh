#!/bin/sh

# DEFAULTS
NAME_TAG=""
APP_NAME="spring-argocd-app"
VERSION="1.0"
REPO_PREFIX="sample/"
PORT=80


############# COMMAND LINE PARAMETERS #############
# VERIFY A VERSION WAS PROVIDED
if [ "$#" -lt 1 ]
then
  NAME_TAG=$REPO_PREFIX$APP_NAME:$VERSION
else
  NAME_TAG=$REPO_PREFIX$APP_NAME:$1
fi
echo "TAG USED: $NAME_TAG"

# VERIFY A PORT WAS PROVIDED
if [ "$#" -lt 2 ]
then
  PORT=$PORT
else
  PORT=$2
fi
echo "PORT USED: $PORT"


############# DOCKER WORK #############
# BUILD CONTAINER
echo "----STARTING DOCKER BUILD"
docker build -t $NAME_TAG .
echo "----FINISHED DOCKER BUILD"

# RUN CONTAINER
echo "----STARTING DOCKER RUN"
docker run -p $PORT:$PORT $NAME_TAG

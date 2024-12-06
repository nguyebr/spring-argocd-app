#!/bin/sh

# DEFAULTS
NAME_TAG=""
APP_NAME="spring-argocd-app"
VERSION="1.0"
REPO_PREFIX="sample/"
ECR_REPO_NAME="$REPO_PREFIX$APP_NAME"
REGION=us-east-1

############# COMMAND LINE PARAMETERS #############
# VERIFY A VERSION WAS PROVIDED
if [ "$#" -lt 1 ]
then
  NAME_TAG=$REPO_PREFIX$APP_NAME:$VERSION
else
  NAME_TAG=$REPO_PREFIX$APP_NAME:$1
fi
echo "TAG USED: $NAME_TAG"

############# DOCKER LOGIN #############
echo "----STARTING RETRIEVAL OF ECR REPOSITORY URI"
ECR_REPO_URI=`aws ecr describe-repositories --repository-names $ECR_REPO_NAME --query 'repositories[].repositoryUri | [0]'`
# Remove the double quotes
ECR_REPO_URI=`sed -e 's/^"//' -e 's/"$//' <<<"$ECR_REPO_URI"`
echo "ECR REPO URI: $ECR_REPO_URI"
echo

echo "----STARTING DOCKER LOGIN"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_REPO_URI
echo "----FINISHED DOCKER LOGIN"
echo

############# DOCKER PUSH #############
echo "----STARTING DOCKER BUILD"
# docker tag $NAME_TAG $ECR_REPO_URI:$VERSION
docker build -t $NAME_TAG .
echo

echo "----STARTING DOCKER TAG"
docker tag $NAME_TAG $ECR_REPO_URI:$VERSION
echo

echo "----STARTING DOCKER PUSH"
docker push $ECR_REPO_URI:$VERSION

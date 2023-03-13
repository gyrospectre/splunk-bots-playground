#!/bin/sh
set -e

log () {
    echo '\n['`date "+%Y/%m/%d %H:%M:%S"`'] #--> \033[0;38;5;214m'$1'\033[0m'
}

REPO="splunk_playground"

ACCOUNT_ID=`aws sts get-caller-identity --output text --query 'Account'`
REGION=`aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'`

ECR_REGISTRY=${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

log "Logging Docker into ECR..."

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_REGISTRY

cd docker
if [ ! -f "botsv3_data_set.tgz" ]; then
    log "Downloading BOTSv3 dataset..."
    curl "https://botsdataset.s3.amazonaws.com/botsv3/botsv3_data_set.tgz" -o botsv3_data_set.tgz
fi

log "Validating BOTSv3 dataset checksum..."
shasum -c checksum

log "Building docker image..."
docker build . -t $ECR_REGISTRY/$REPO:latest

repo_check=$(aws ecr describe-repositories --repository-names ${REPO} 2>&1 || true)
if echo ${repo_check} | grep -q RepositoryNotFoundException; then
    log "ECR repo does not exist. Creating..."
    aws ecr create-repository --repository-name ${REPO} >/dev/null
fi

log "Pushing docker image to ECR..."
docker push ${ECR_REGISTRY}/${REPO}:latest

log "Done!"
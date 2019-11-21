#!/bin/sh -x
#
# Copyright (C) 2019 Qualys - All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
#
# Builds api-example-python image
#
# Expected usage:
#   build/build-image.sh # (eg run from parent dir)
###

set -e

if [ -z "$bamboo_API_TYPE" ]; then
  #API_VERSION_PATH="/crs/v1.2/api"
  bamboo_API_TYPE=private
else
  #API_VERSION_PATH="/csapi/v1.2/runtime"
  sed -i -e 's,API_VERSION_PATH="/crs/v1.2/api",API_VERSION_PATH="/csapi/v1.2/runtime",' li_utils/envtools.py
fi

IMAGE_REPO="art-hq.intranet.qualys.com:5001/qualys/crs/api-${bamboo_API_TYPE}-example-python"
if [ -z "$IMAGE_NAME" ]; then
    IMAGE_NAME="$IMAGE_REPO"
fi

if [ -z "${bamboo_image_tag}" ]; then
  # use date tag only for plan branch, push to plan branch tag too (develop)
  if [ "$bamboo_customRevision" = "" ]; then
    #IMAGE_TAG=`date "+%Y%m%d"`
    #IMAGE_NAME="$IMAGE_NAME:$IMAGE_TAG"
    IMAGE_NAME="$IMAGE_REPO:${bamboo_planRepository_branchName}"
  else
    # only push to branch tag for customRevision/branch builds
    IMAGE_NAME="$IMAGE_REPO:$bamboo_customRevision"
  fi
else
  IMAGE_NAME="$IMAGE_REPO:${bamboo_image_tag}-${bamboo_buildNumber}"
fi

if [ -z "$CI_PROJECT_DIR" ]; then
    CI_PROJECT_DIR=/data
fi

PYTHON_CLIENT=swagger-${bamboo_API_TYPE}-client-codegen-1.6.2.0-6.zip
wget -q https://art-hq.intranet.qualys.com/artifactory/crs/$PYTHON_CLIENT
unzip $PYTHON_CLIENT

docker build -t $IMAGE_NAME -f build/Dockerfile-bamboo .
docker push $IMAGE_NAME

# push date tag only for plan branch and if bamboo_image_tag not set
if [ "$bamboo_customRevision" = "" ] && [ -z "${bamboo_image_tag}" ]; then
  IMAGE_TAG=`date "+%Y%m%d"`
  tag="$IMAGE_REPO:$IMAGE_TAG"
  docker tag $IMAGE_NAME $tag
  docker push $tag
  docker rmi $tag
fi

# Cleanup
docker rmi $IMAGE_NAME

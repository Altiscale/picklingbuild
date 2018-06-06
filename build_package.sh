#!/usr/bin/env bash

cd ${WORKSPACE}

echo "ok - $(whoami) user is going to build the project"
echo "ok - fpm is located at $(which fpm)"
echo "ok - PATH=$PATH"
echo "ok - BUILD_BRANCH=$BUILD_BRANCH"
echo "ok - PACKAGE_BRANCH=$PACKAGE_BRANCH"

pushd ${WORKSPACE}
UNZIP_DIR="pickling-$(echo $PACKAGE_BRANCH | tr -d 'v')"
wget -O $PACKAGE_BRANCH.zip https://github.com/Altiscale/pickling/archive/$PACKAGE_BRANCH.zip
if [ -d ./$UNZIP_DIR ] ; then
  rm -rf ./$UNZIP_DIR
fi
unzip $PACKAGE_BRANCH.zip
pushd $UNZIP_DIR
sbt package
popd
popd

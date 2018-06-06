#!/bin/bash -x

cd ${WORKSPACE}

echo "ok - $(whoami) user is going to build the project"
echo "ok - fpm is located at $(which fpm)"
echo "ok - PATH=$PATH"
echo "ok - BUILD_BRANCH=$BUILD_BRANCH"
echo "ok - PACKAGE_BRANCH=$PACKAGE_BRANCH"

ret=0
export DATE_STRING=${DATE_STRING:-$(date -u +%Y%m%d%H%M)}
INSTALL_DIR=${WORKSPACE}/install-dir-${DATE_STRING}
pushd ${WORKSPACE}

# pushd ${WORKSPACE}/pickling
# sbt package
# ret=$?

# This is a hack to just package the JAR before we can build it correctly
# hack_target should exist already with the JARs we need
export RPM_NAME=`echo scala-pickling-${PACKAGE_BRANCH}`
export RPM_DESCRIPTION="scala-pickling library ${PACKAGE_BRANCH}"

##################
# Packaging  RPM #
##################
export RPM_BUILD_DIR="${INSTALL_DIR}/usr/sap/spark/controller/"
# Generate RPM based on where spark artifacts are placed from previous steps
rm -rf "${RPM_BUILD_DIR}"
mkdir --mode=0755 -p "${RPM_BUILD_DIR}"

pushd hack_target
if [[ "$PACKAGE_BRANCH" == *_2.10 ]] ; then
  mkdir --mode=0755 -p "${RPM_BUILD_DIR}/lib"
  cp -rp scala-pickling_2.10-*.jar $RPM_BUILD_DIR/lib/
elif [[ "$PACKAGE_BRANCH" == *_2.11 ]] ; then
  mkdir --mode=0755 -p "${RPM_BUILD_DIR}/lib_2.11"
  cp -rp scala-pickling_2.11-*.jar $RPM_BUILD_DIR/lib_2.11/
else
  echo "fatal - unsupported version for $PACKAGE_BRANCH, can't produce RPM, quitting!"
  exit -1
fi

pushd ${RPM_DIR}
fpm --verbose \
--maintainer andrew.lee02@sap.com \
--vendor SAP \
--provides ${RPM_NAME} \
--description "$(printf "${RPM_DESCRIPTION}")" \
--replaces ${RPM_NAME} \
--url "https://github.com/Altiscale/pickling" \
--license "Proprietary" \
--epoch 1 \
--rpm-os linux \
--architecture all \
--category "Development/Libraries" \
-s dir \
-t rpm \
-n ${RPM_NAME} \
-v ${PACKAGE_BRANCH} \
--iteration ${DATE_STRING} \
--rpm-user root \
--rpm-group root \
--rpm-auto-add-directories \
-C ${INSTALL_DIR} \
usr

if [ $? -ne 0 ] ; then
	echo "FATAL: scala-pickling rpm build fail!"
	popd
	exit -1
fi
popd

exit 0

#!/bin/bash -l

set -e

RPMDIR=$1

# Pre install extra packages (epel repo, etc.)
env | grep EXTRA > /tmp/extras
while i= read -r line
do
    REPO=${line##*=}
    sudo yum install -y $REPO
done < /tmp/extras

name=`rpmspec --srpm -q --qf "%{Name}" ${RPMDIR}/*.spec`
version=`rpmspec --srpm -q --qf "%{Version}" ${RPMDIR}/*.spec`
release=`rpmspec --srpm -q --qf "%{Release}" ${RPMDIR}/*.spec`

cp ${RPMDIR}/* /home/builder/rpm/

echo "install build deps"
sudo yum-builddep /home/builder/rpm/*.spec

echo "create source tarball"
mkdir -p /tmp/${name}-${version}/
cp -a . /tmp/${name}-${version}/
rm -rf /tmp/${name}_${version}.orig/.git
rm -rf /tmp/${name}_${version}.orig/rpm
tar cvfz /home/builder/rpm/${name}-${version}.tar.gz -C /tmp ${name}-${version}
rm -rf /tmp/${name}-${version}

echo "build package"
export HOME=/home/builder
rpmbuild -ba /home/builder/rpm/*.spec

echo "lint packages"
rpmlint /home/builder/rpm/*/*.rpm

echo "rpm version: ${version}-${release}"
echo ::set-output name=rpmversion::${version}-${release}


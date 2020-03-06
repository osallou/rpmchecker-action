#!/bin/bash -l

set -e

name=`rpmspec --srpm -q --qf "%{Name}" rpm/*.spec`
version=`rpmspec --srpm -q --qf "%{Version}" rpm/*.spec`
release=`rpmspec --srpm -q --qf "%{Release}" rpm/*.spec`

cp rpm/* /home/builder/rpm/

echo "install build deps"
sudo yum-builddep /home/builder/rpm/*.spec

echo "create source tarball"
mkdir -p /tmp/${name}-${version}/
cp -a . /tmp/${name}-${version}/
rm -rf /tmp/${name}_${version}.orig/.git
rm -rf /tmp/${name}_${version}.orig/rpm
tar cvfz /home/builder/rpm/${name}-${version}.tar.gz -C /tmp ${name}-${version}
rm -rf /tmp/${name}-${version}

cd /home/builder
echo "build package"
rpmbuild -ba /home/builder/rpm/*.spec

echo "lint packages"
rpmlint /home/builder/rpm/*/*.rpm

echo "rpm version: ${version}-${release}"
echo ::set-output name=rpmversion::${version}-${release}


# rpm-checker-action

## About

github action to test rpm package build against centos 7

* install build-deps
* build package
* run rpmlint
* outputs rpm version from spec file

Simply expects to have a rpm directory in root repo path with at least a spec file,
and all other expected files if any (patches, ....).
Source is built automatically from git repo but expects to be name Name-Version.tar.gz

Directory containing spec file etc. is, by default, *rpm*,
but an other relative location can be specified with action
input path-to-rpm

Support env variables EXTRA_XX to pre-install some packages (EPEL repo for example).
Example:

    env:
        EXTRA_1: epel-release

If a *rpmlint* file is present in *path-to-rpm* directory, will be used as
rpm config file to filter errors.

## Roadmap

* manage as input name of source file
* different images (fedora, suse, ?)

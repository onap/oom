#!/bin/bash

cd src/config

TAR=/usr/local/opt/gnu-tar/libexec/gnubin/tar
OS="`uname`"
case $OS in
  'Linux')
    OS='Linux'
    TAR=/usr/bin/tar
    ;;
  'Darwin')
    OS='Mac'
    ;;
  *) ;;
esac

$TAR -cvzf ../../onap-cfg.tar.gz *

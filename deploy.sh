#!/bin/bash

export APP_NAME="ld26"
export SSH_HOST="netmute.org"
export APP_DIR="/var/www/$APP_NAME"

echo Deploying...
pushd "export" > /dev/null 2>&1 &&
tar cfhz ../bundle.tgz . > /dev/null 2>&1 &&
popd > /dev/null 2>&1 &&
scp bundle.tgz $SSH_HOST:/tmp/ > /dev/null 2>&1 &&
rm bundle.tgz > /dev/null 2>&1 &&
ssh $SSH_HOST 'bash -s' > /dev/null 2>&1 <<ENDSSH
if [ ! -d "$APP_DIR" ]; then
  mkdir -p $APP_DIR
else
  rm -rf $APP_DIR/*
fi
pushd $APP_DIR
  tar xfz /tmp/bundle.tgz --no-same-owner -C $APP_DIR
  rm /tmp/bundle.tgz
popd
ENDSSH
echo Done.

#!/bin/sh
set -e

#========

CheckFileAndPermissions(){
  if [ $# -lt 1 ]; then
    echo "Parameter miss"
    return 1
  fi

  if [ ! -f $1 ]; then
    echo "Generate '$1' file"
    touch $1
    if [ $? -ne 0 ];then
      echo "Generate '$1' file error"
      return 1
    fi
  fi

  chmod 600 $1
  if [ $? -ne 0 ];then
    echo "'$1' Set file permission error"
    return 1
  fi

  return 0
}

#========

echo "Starting check and setting config"

if [ ! -d /config/ ]; then
  mkdir -p /config/
fi

if [ ! -f /config/aria2.conf ]; then
  echo "Generate an aria2 configuration file from default"
  cp /aria2.conf.default /config/aria2.conf

  echo "Generate RPC-Secret"
  UUID=$(cat /proc/sys/kernel/random/uuid)
  sed -i "s/^# rpc-secret=<TOKEN>\$/rpc-secret=$UUID/g" /config/aria2.conf
else
  echo "Use existing profiles"
fi

CheckFileAndPermissions /config/aria2.conf
CheckFileAndPermissions /config/netrc
CheckFileAndPermissions /config/srvstat
CheckFileAndPermissions /config/cookies
CheckFileAndPermissions /config/dht
CheckFileAndPermissions /config/dht6
CheckFileAndPermissions /config/session

echo "[DONE]"
echo

#========

echo 'Starting aria2 server'
exec aria2c --conf-path=/config/aria2.conf \
     > /dev/stdout \
     2 > /dev/stderr
echo 'Exitine aria2 server'
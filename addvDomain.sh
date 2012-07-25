#!/bin/bash

trap "echo Booh!; exit -1" SIGINT SIGTER

PATH=$(dirname $0)
# load config
if [ -f $PATH/conf.conf ]
then
    source $PATH/conf.conf
fi
if [ -f $PATH/conf.local ]
then
    source $PATH/conf.local
fi


if [ ! $# = 1 ]
 then
  echo "Usage: $0 domain"
  exit 1
 else
  domain=$1
  if [ -x $domain ]
   then
    echo "No domain given\nUsage: $0 domain"
    exit 2
  fi

  if [ ! -f /etc/postfix/vdomains ]
  then 
      touch /etc/postfix/vdomains
  fi
  grep -q $domain /etc/postfix/vdomains
  if [ $? -eq 1 ]
   then
    echo "Insert Domain $domain in /etc/postfix/vdomains"
    echo "$domain" >> /etc/postfix/vdomains
    postfix reload
  else
    echo "Domain already in list"
  fi
fi

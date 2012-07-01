#!/bin/bash

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

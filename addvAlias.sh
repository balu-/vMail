#!/bin/bash
if [ ! $# = 2 ]
 then
  echo "Usage: $0 username@domain alias@domain,alias2@domain.."
  exit 1
 else
  user=`echo "$1" | cut -f1 -d "@"`
  domain=`echo "$1" | cut -s -f2 -d "@"`
  if [ -x $domain ]
   then
    echo "No domain given\nUsage: $0 username@domain alias@domain,alias2@domain.
."
    exit 2
  fi
  
  if [ ! -f /etc/postfix/valias ]
  then
      touch /etc/postfix/valias
  fi
  grep -q $1 /etc/postfix/valias

  if [ $? -eq 1 ]
    then
      echo "Insert $1 as Alias for $2 in /etc/postfix/valias"
      echo $1 $2 >> /etc/postfix/valias
      postmap /etc/postfix/valias
      #check for vdomain
      grep -q $domain /etc/postfix/vdomains
      if [ $? -eq 1 ]
        then
          #insert in vdomains
          echo "Insert $domain into /etc/postfix/vdomains"
          echo $domain >> /etc/postfix/vdomains
          #postmap /etc/postfix/vdomains
      fi
 
      postfix reload
  else
      echo "Alias already in list"
  fi
fi

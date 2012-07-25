#!/bin/bash
trap "echo Booh!; exit -1" SIGINT SIGTERM

PATH=$(dirname $0)
# load config  
if [ -f $PATH/conf.conf ]
then
    source $PATH/conf.conf
else    
    echo "No Config present"
    exit -1;
fi
if [ -f $PATH/conf.local ]
then
    source $PATH/conf.local
fi


if [ ! $# = 1 ]
 then
  echo "Usage: $0 username@domain"
  exit 1
 else 
  user=`echo "$1" | cut -f1 -d "@"`
  domain=`echo "$1" | cut -s -f2 -d "@"`
  if [ -x $domain ]
   then
    echo "No domain given\nUsage: $0 username@domain"
    exit 2
  fi
  if [ -f /var/mail/auth.d/$domain/passwd ]
   then 
    grep -q "$user@$domain" /var/mail/auth.d/$domain/passwd
    if [ $? -eq 0 ]
     then
         echo "User $user@$domain does not exist"
         exit 0
     fi
  else
      echo "File /var/mail/auth.d/$domain/passwd does not exist"
      exit 0
  fi
  echo " \nCreate a new password for $user@$domain"
  passwd=`dovecotpw -s ssha256`
  echo "Change password for $user@$domain in /var/mail/auth.d/$domain/passwd"
  sed -e "s/^$user@$domain.*$/$passwd/" /var/mail/auth.d/$domain/passwd > /var/mail/auth.d/$domain/passwd


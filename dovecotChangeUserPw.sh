#!/bin/bash
trap "echo Booh!; exit -1" SIGINT SIGTERM

MYPATH=$(dirname $0)
# load config  
if [ -f $MYPATH/conf.conf ]
then
    source $MYPATH/conf.conf
else    
    echo "No Config present"
    exit -1;
fi
if [ -f $MYPATH/conf.local ]
then
    source $MYPATH/conf.local
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
    if [ $? -eq 1 ]
     then
         echo "User $user@$domain does not exist"
         exit 0
     fi
  else
      echo "File /var/mail/auth.d/$domain/passwd does not exist"
      exit 0
  fi
  echo " \nCreate a new password for $user@$domain"
  passwd=`dovecotpw -s ssha256 | sed -e 's/\([[\/.*]\|\]\)/\\&/g'`
  echo "Change password for $user@$domain in /var/mail/auth.d/$domain/passwd"
  addr=$(printf "${user}@${domain}:" | sed -e 's/\([[\/.*]\|\]\)/\\&/g') # escape regex chars
  sed -r 's/^('$addr').*$/\1'$passwd'/' /var/mail/auth.d/$domain/passwd > /var/mail/auth.d/$domain/passwd
fi

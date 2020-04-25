#!/bin/bash

ERROR='\e[38;5;1mERROR:\e[38;5;231m'
WARN='\e[38;5;11mWARN:\e[38;5;231m'
INFO='\e[38;5;38mINFO:\e[38;5;231m'

SUCCESS='\e[38;5;2m'
RESET='\e[38;5;231m'

node -v > /dev/null 2>&1
if [[ "$?" -ne 0 ]] ; then
  echo -e $INFO 'Installing node';
  apt install -y nodejs > /dev/null 2>&1
  if [[ "$?" -ne 0 ]] ; then
    echo -e $ERROR 'Failed to install node';
  else
    echo -e $INFO $SUCCESS"nodejs installed" $RESET
  fi
fi

npm -v > /dev/null 2>&1
if [[ "$?" -ne 0 ]] ; then
  echo -e $INFO 'Installing npm';
  apt install -y npm > /dev/null 2>&1
  if [[ "$?" -ne 0 ]] ; then
    echo -e $ERROR 'Failed to install npm';
  else
    echo -e $INFO $SUCCESS"nodejs installed" $RESET
  fi
fi

mysql -V > /dev/null 2>&1
if [[ "$?" -ne 0 ]] ; then
  echo -e $INFO 'Installing mysql-server';
  apt install -y mysql-server > /dev/null 2>&1
  if [[ "$?" -ne 0 ]] ; then
    echo -e $ERROR 'Failed to install mysql-server';
  else
    systemctl enable mysql.service
    echo -e $INFO $SUCCESS"mysql-server installed" $RESET
  fi
fi

ionic -v > /dev/null 2>&1
if [[ "$?" -ne 0 ]] ; then
  echo -e $INFO 'Installing Ionic';
  npm install -g @ionic/cli > /dev/null 2>&1
  if [[ "$?" -ne 0 ]] ; then
    echo -e $ERROR 'Failed to install Ionic';
  else
    systemctl enable mysql.service
    echo -e $INFO $SUCCESS"Ionic installed" $RESET
  fi
fi

echo -e $SUCCESS"Done" $RESET

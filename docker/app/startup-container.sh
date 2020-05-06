#!/usr/bin/env bash

##
# Ensure /.composer exists and is writable
#
if [ ! -d /.composer ]; then
    mkdir /.composer
fi

chmod -R ugo+rw /.composer

if [ ! -d /var/www/html/src/public ]; then
    git clone https://github.com/narcisonunez/mvc-base.git .
    cp env.values .env
    mkdir logs
    touch logs/server.error.log
    composer install
fi

##
# Run a command or start supervisord
#
if [ $# -gt 0 ];then
    # If we passed a command, run it
    exec "$@"
else
    # Otherwise start supervisord
    /usr/bin/supervisord
fi
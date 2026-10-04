#!/bin/bash
USER=$1

if [ -n "$USER" ]; then
	/usr/bin/mkdir -p /data/users/$1 && /usr/bin/chown -R $1:"domain admins" /data/users/$1 && /usr/bin/chmod -R 2770 /data/users/$1
fi

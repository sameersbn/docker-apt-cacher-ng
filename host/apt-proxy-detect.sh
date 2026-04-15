#!/bin/bash

if [ -z $APT_CACHER_NG_IP ]
then
    echo -n "DIRECT"
    exit
fi

if [ -z $APT_CACHER_NG_PORT ]
then
    echo -n "DIRECT"
    exit
fi

if nc -w1 -z "$APT_CACHER_NG_IP" "$APT_CACHER_NG_PORT" 2> /dev/null
then
    echo -n "http://${APT_CACHER_NG_IP}:${APT_CACHER_NG_PORT}"
else
    echo -n "DIRECT"
fi

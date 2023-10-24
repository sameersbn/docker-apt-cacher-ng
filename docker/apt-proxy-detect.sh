#!/bin/bash

IP=172.17.0.1
PORT=3142
if nc -w1 -z $IP $PORT 2> /dev/null
then
    echo -n "http://${IP}:${PORT}"
else
    echo -n "DIRECT"
fi

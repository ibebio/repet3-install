#!/usr/bin/env bash

echo "Soft killing all running user udocker and mysql processes ..."
parallel 'kill {}' ::: $(ps -fu $USER |grep -E 'mysql|udocker' | awk {'print $2'})

echo "Waiting 15s"
sleep 15s

echo "Hard killing all running user udocker and mysql processes ..."
parallel 'kill -9 {}' ::: $(ps -fu $USER |grep -E 'mysql|udocker' |awk {'print $2'})
echo "Done"

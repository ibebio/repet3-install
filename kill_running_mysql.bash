#!/usr/bin/env bash

echo "Soft killing all running user udocker and mysql processes ..."
parallel 'kill {}' ::: $(ps aux |grep -E 'mysql|udocker' |grep $USER |awk {'print $2'})

echo "Waiting 15s"
sleep 15s

echo "Hard killing all running user udocker and mysql processes ..."
parallel 'kill -9 {}' ::: $(ps aux |grep -E 'mysql|udocker' |grep $USER |awk {'print $2'})
echo "Done"

#!/usr/bin/env bash

set -xv

###############################################################################
# Set variables, source them from the mysql_env.bash file in the same directory
# as the script

SCRIPT_DIR=$(dirname $0)
source ${SCRIPT_DIR}/mysql_env.bash

#
###############################################################################


###############################################################################
# Create mysql docker image

# Kill existing udocker/mysql user processes.
${SCRIPT_DIR}/kill_running_mysql.bash

# Check if container already exists, if so, delete it.
if [[ $(udocker ps |grep -c \'${MYSQL_CONTAINER}\') != 0 ]] ; then
  udocker rm ${MYSQL_CONTAINER}
fi
udocker create --name=${MYSQL_CONTAINER} mysql:8.0
#
###############################################################################


###############################################################################
# Create REPET database

# Run the udocker MySql
export PROOT_NO_SECCOMP=1
udocker run \
  --env="MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" \
  --env="MYSQL_TCP_PORT=${MYSQL_TCP_PORT}" \
  --env="DEFAULT_STORAGE_ENGINE=INNODB" \
  ${MYSQL_CONTAINER} &

while ! nc -z localhost ${MYSQL_TCP_PORT}; do
  sleep 1 # wait for 1 sec
  echo "Waiting for MySql container to start up ..."
done

echo "Creating the REPET user repet with the password repet and the database repet_db"

# Run MySql commands to create the database
mysql -h127.0.0.1 -P${MYSQL_TCP_PORT} -uroot -p${MYSQL_ROOT_PASSWORD} -e"SET default_storage_engine=INNODB;"
mysql -h127.0.0.1 -P${MYSQL_TCP_PORT} -uroot -p${MYSQL_ROOT_PASSWORD} -e"CREATE USER 'repet'@'%' IDENTIFIED BY 'repet';"
mysql -h127.0.0.1 -P${MYSQL_TCP_PORT} -uroot -p${MYSQL_ROOT_PASSWORD} -e"CREATE DATABASE repet_db;"
mysql -h127.0.0.1 -P${MYSQL_TCP_PORT} -uroot -p${MYSQL_ROOT_PASSWORD} -e"GRANT ALL PRIVILEGES ON repet_db.* TO 'repet'@'%';"

# Kill all child processes spawned by udocker
# pkill -P $$ # does not work

echo "Stopping all processess spawned by the udocker MySql container"
kill $(ps  |egrep -vw 'PID|bash' | awk '{print $1}')
#
###############################################################################

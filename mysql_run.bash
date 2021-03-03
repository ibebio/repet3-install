#!/usr/bin/env bash

# Set bash strict mode
set -euo pipefail

###############################################################################
# Set variables, source them from the mysql_env.bash file in the same directory
# as the script

source $(dirname $0)/mysql_env.bash

BIND_ADDRESS=172.18.3.222  # burrito for cluster access

#
###############################################################################


# Kill existing udocker/mysql processes
$(dirname $0)/kill_running_mysql.bash

# Run the udocker MySql

echo "Starting MySql Container"
echo "If you did not run it with $0 &, press Ctrl-Z, and type 'bg' to put it"
echo "into background"

export PROOT_NO_SECCOMP=1
udocker run \
  --env="MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" \
  --env="MYSQL_TCP_PORT=${MYSQL_TCP_PORT}" \
  --env="BIND_ADDRESS=${BIND_ADDRESS}" \
  --env="DEFAULT_STORAGE_ENGINE=MyISAM" \
  ${MYSQL_CONTAINER} &

while ! nc -z localhost ${MYSQL_TCP_PORT}; do
  sleep 1 # wait for 1 sec
  echo "Waiting for MySql container to start up ..."
done

mysql -h127.0.0.1 -P${MYSQL_TCP_PORT} -uroot -p${MYSQL_ROOT_PASSWORD} -e"SET default_storage_engine=MyISAM;"

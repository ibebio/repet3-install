###############################################################################
# Set variables
MYSQL_CONTAINER=mysql-${USER}
MYSQL_ROOT_PASSWORD=password

# Get a random free port for MySql
MYSQL_TCP_PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')

echo "The MySql TCP port is now ${MYSQL_TCP_PORT}"
echo "IMPORTANT: it will be different next time this command is run!"
#
###############################################################################

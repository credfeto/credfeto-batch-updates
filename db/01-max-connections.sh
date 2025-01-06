#! /bin/sh
sed -i "s/max_connections = 100/max_connections = 512/" /var/lib/postgresql/data/postgresql.conf

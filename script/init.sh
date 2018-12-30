#!/bin/bash
# docker run --name sovrin -i -p 4005:3000 oydeu/srv-sovrin /bin/init.sh "$(< ~/oyd/blockchain/config/srv_sovrin_input.json)"
# curl http://localhost:4005/api/did/new

rm -f /usr/src/app/tmp/pids/server.pid /usr/src/app/log/*.log
rails server -b 0.0.0.0 &
bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:3000)" != "200" ]]; do sleep 5; done'
/usr/src/app/script/init.rb "$1"
sleep infinity
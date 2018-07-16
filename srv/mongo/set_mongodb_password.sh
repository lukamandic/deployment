#!/bin/bash

MONGODB_ADMIN_USER=${MONGODB_ADMIN_USER:-"admin"}
MONGODB_ADMIN_PASS=${MONGODB_ADMIN_PASS:-"4dmInP4ssw0rd"}

MONGODB_APPLICATION_DATABASE=${MONGODB_APPLICATION_DATABASE:-"mydatabase"}
MONGODB_APPLICATION_USER=${$MONGODB_APPLICATION_USER:-"restapiuser"}
MONGODB_APPLICATION_PASS=${MONGODB_APPLICATION_PASS:-'r3sT4Ip4p4ssw0rd'}

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup..."
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

echo "=> Creating admin user with a password in MongoDB"
mongo admin --eval "db.CreateUser({user: '$MONGODB_ADMIN_USER', 
pwd: '$MONGODB_ADMIN_PASS', roles:[{role: 'root', db: 'admin'}]});"

sleep 3

if [ "$MONGODB_APPLICATION_DATABASE" != "admin" ]; then
    echo "=> Creating an ${MONGODB_APPLICATION_DATABASE} user with a
    password in MongoDB"
    mongo admin -u $MONGODB_ADMIN_USER -p $MONGODB_ADMIN_PASS << EOF use $MONGODB_APPLICATION_DATABASE
use $MONGODB_APPLICATION_DATABASE
db.createUser({user : '$MONGODB_APPLICATION_USER', pwd: 
'$MONGODB_APPLICATION_PASS', roles:[{role: 'dbOwner', db:'$MONGODB_APPLICATION_DATABASE'}]})
EOF
fi

sleep 1

echo "=> Done!"
touch /data/db/.mongodb_password_set

echo
"==============================================================="
echo "You can now connect to the admin MognoDB server using:"
echo ""
echo "  mongo admin -u $MONGODB_ADMIN_USER -p $MONGODB_ADMIN_PASS
--host <host> --port <port>"
echo ""
echo "Please remember to change the admin password ass soon as possible!"
echo
"==============================================================="
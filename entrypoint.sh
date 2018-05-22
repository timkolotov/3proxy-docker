#!/bin/sh

if [ -z "$HTTP_PORT" ]; then
    # set default port
    export HTTP_PORT=8080
fi

if [ -z "$SOCKS_PORT" ]; then
    # set default port
    export SOCKS_PORT=1080
fi

# copy config template and replace variables (only first run)
cp -u /etc/3proxy.cfg.tpl /etc/3proxy.cfg && grep -q "__INET__" /etc/3proxy.cfg
if [ $? -eq 0 ]; then
    sed -i 's/__INET__/'"$(hostname -i)"'/g' /etc/3proxy.cfg
    sed -i 's/__HTTP_PORT__/'"$HTTP_PORT"'/g' /etc/3proxy.cfg
    sed -i 's/__SOCKS_PORT__/'"$SOCKS_PORT"'/g' /etc/3proxy.cfg
    sed -i 's/__NOBODY__/'"$(id -u nobody)"'/g' /etc/3proxy.cfg
fi

# if passwd file is empty - create new user
if [ $(wc -l < /etc/3proxy/passwd) -eq 0 ]; then
    if [ -z "$USER" ]; then
        # set default user
        export USER="proxyman"
    fi
    if [ -z "$PASS" ]; then
        # if password not set - generate it
        export PASS="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | fold -w 10 | head -n 1)"
    fi
    echo "$USER:CL:$PASS" > /etc/3proxy/passwd
elif [ $(wc -l < /etc/3proxy/passwd) -eq 1 ]; then
    # hm...
    USER=$(cat /etc/3proxy/passwd | awk -F ":CL:" '{ print $1 }')
    PASS=$(cat /etc/3proxy/passwd | awk -F ":CL:" '{ print $2 }')
fi

# print some information
echo "---------------------------------------------------------------"
if [ ! -z "$USER" ] && [ ! -z "$PASS" ]; then
    echo "Login credentials  -   user:  $USER  /  password: $PASS"
else
    echo "Login credentials  -   loaded from /etc/3proxy/passwd"
fi
echo "Proxy HTTP port:       $HTTP_PORT"
echo "Proxy SOCKS5 port:     $SOCKS_PORT"
echo "---------------------------------------------------------------"

# run 3proxy server
3proxy /etc/3proxy.cfg

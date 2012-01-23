#! /bin/sh
# Change properties through dyn/admin on the fly
# created by @author William Dennett(wdennett@atg.com)
# parameters:
# 1: component path to be changed - requires the trailing slash
# 2: name of the property to be changed
# 3: new value of the property to be changed
# 4: port te port on which dyn admin is running
# 5: host the host on which to perform the change
# Note that the last two are optional, and will default to
# localhost:8080, but because of the parameter ordering it is
# possible to miss off the host and change multiple properties
# on multiple local instances of atg on jboss.
usage(){
    echo "changeProperty <component> <property> <value> [port host ]"
    exit 1;
}
host=$5
port=$4
property=$1
name=$2
value=$3
if [ "${host}x" = "x" ]; then
	host='localhost'
fi
if [ "${port}x" = "x" ]; then
	port='8080'
fi
if [ "${property}x" = "x" ]; then
        usage
fi
if [ "${name}x" = "x" ]; then
        usage
fi
if [ "${value}x" = "x" ]; then
        usage
fi
curl -u admin:admin -d propertyName=${name} -d newValue=${value} -d change=Change+Value "http://${host}:${port}/dyn/admin/nucleus${property}"

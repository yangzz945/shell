rediscli="/opt/redis/src/redis-cli"
key=$1
#param=" -h 10.100.23.32 -p 8001 "
for each in `cat sessionServers`; do
    ip=`echo $each | awk -F":" '{print $1}'`
    port=`echo $each | awk -F":" '{print $2}'`
    param=" -h $ip -p $port "
    result=$( $rediscli $param type $key)
    value=""
    if [ $result == "list" ]
        then
            value=$( $rediscli $param lrange $key 0 -1)
    elif [ $result == "string" ]
        then
            value=$( $rediscli $param get $key)
    elif [ $result == "hash" ]
        then
            value=$( $rediscli $param hgetall $key)
elif [ $result == "set" ]
        then
            value=$( $rediscli $param smembers $key)
    elif [ $result == "none" ]
        then
            continue
    fi

    printf "%s\t %s\t %s\t %s\t %s\n" $ip $port $result $key $value
done
            

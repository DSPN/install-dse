#!/usr/bin/env bash

#
# generate cassandra-rackdc.properties.new
#
dc=$data_center_name
rack=$rack
cat cassandra-rackdc.properties \
| sed -e "s:^\(dc\=\).*:dc\=$dc:" \
| sed -e "s:^\(rack\=\).*:rack\=$rack:" \
> cassandra-rackdc.properties.new
(set -x; chown cassandra:cassandra cassandra-rackdc.properties.new)
(set -x; diff cassandra-rackdc.properties cassandra-rackdc.properties.new)
(set -x; mv -f cassandra-rackdc.properties.new cassandra-rackdc.properties )
#
# generate address.yaml.new
#
cd "$agent_conf_dir"
stomp_interface=$opscenter_public_ip
local_interface=$node_private_ip
agent_rpc_broadcast_address=$node_public_ip
agent_rpc_interface=$node_private_ip
use_ssl=0
thrift_max_conns=10
async_pool_size=10
async_queue_size=800000
max_reconnect_time=60000
cat address.yaml \
| sed -e "s:.*\(stomp_interface\:\).*:stomp_interface\: $stomp_interface:" \
| sed -e "s:.*\(local_interface\:\).*:hosts\: \[\"$local_interface\"\]:" \
| sed -e "s:.*\(hosts\:\).*:hosts\: \[\"$local_interface\"\]:" \
| sed -e "s:.*\(use_ssl\:\).*:use_ssl\: $use_ssl:" \
| sed -e "s:.*\(thrift_max_conns\:\).*:thrift_max_conns\: $thrift_max_conns:" \
| sed -e "s:.*\(async_pool_size\:\).*:async_pool_size\: $async_pool_size:" \
| sed -e "s:.*\(max_reconnect_time\:\).*:max_reconnect_time\: $max_reconnect_time:" \
> address.yaml.new
if [ "x$(grep stomp_interface address.yaml)" == x ]; then echo "stomp_interface: $stomp_interface" >> address.yaml.new; fi
if [ "x$(grep hosts address.yaml)" == x ]; then echo "hosts: [\"$local_interface\"]" >> address.yaml.new; fi
if [ "x$(grep use_ssl address.yaml)" == x ]; then echo "use_ssl: $use_ssl" >> address.yaml.new; fi
if [ "x$(grep thrift_max_conns address.yaml)" == x ]; then echo "thrift_max_conns: $thrift_max_conns" >> address.yaml.new; fi
if [ "x$(grep async_pool_size address.yaml)" == x ]; then echo "async_pool_size: $async_pool_size" >> address.yaml.new; fi
if [ "x$(grep async_queue_size address.yaml)" == x ]; then echo "async_queue_size: $async_queue_size" >> address.yaml.new; fi
if [ "x$(grep max_reconnect_time address.yaml)" == x ]; then echo "max_reconnect_time: $max_reconnect_time" >> address.yaml.new; fi
(set -x; chown cassandra:cassandra address.yaml.new)
(set -x; diff address.yaml address.yaml.new)
(set -x; mv -f address.yaml.new address.yaml)

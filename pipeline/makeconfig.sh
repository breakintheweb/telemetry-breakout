#!/bin/sh
cat <<EOF
[default]
id = pipeline
EOF

env | grep ^MDT_DIALIN_HOST_ | cut -d= -f2- | while read line
do
	unset inventory_hostname ansible_ssh_host ansible_ssh_user ansible_ssh_pass mdt_port mdt_subscriptions
	eval inventory_hostname=$line
	
	encryptedpw=
	for line in $(echo -n ${ansible_ssh_pass:-$MDT_DIALIN_PASS} | openssl pkeyutl -encrypt -inkey $RSA_KEY -pkeyopt rsa_padding_mode:oaep -pkeyopt rsa_oaep_md:sha256 -pkeyopt rsa_mgf1_md:sha256 | openssl enc -base64)
	do
		encryptedpw=$encryptedpw$line
	done
	
	cat <<EOF
[dialin_$inventory_hostname]
stage = xport_input
type = grpc
encap = gpb
encoding = gpbkv
server = $ansible_ssh_host:${mdt_port:-$MDT_DIALIN_PORT}
username = ${ansible_ssh_user:-$MDT_DIALIN_USER}
password = $encryptedpw
subscriptions = ${mdt_subscriptions:-$MDT_DIALIN_SUBSCRIPTIONS}
EOF
done

if [ -n "$DIALOUT_PORT" ]; then
	if [ -z "$DIALOUT_ENCAP" -a "$DIALOUT_TYPE" == grpc ]; then
		DIALOUT_ENCAP=gpb
	else
		DIALOUT_ENCAP=st
	fi
	
	cat <<EOF
[dialout]
stage = xport_input
type = ${DIALOUT_TYPE:-tcp}
encap = $DIALOUT_ENCAP
listen = :$DIALOUT_PORT
tls = false
EOF

fi

if [ -n "$DUMP_FILE" ]; then
	cat <<EOF
[inspector]
stage = xport_output
type = tap
file = $DUMP_FILE
EOF

	if [ -n "$DUMP_ENCODING" ]; then
		echo "encoding = $TAP_ENCODING"
	else
		echo "raw = true"
	fi
fi

if [ -n "$INFLUX_URL" ]; then
	INFLUX_ENCODEDPW=
	for line in $(echo -n $INFLUX_PASSWORD | openssl pkeyutl -encrypt -inkey $RSA_KEY -pkeyopt rsa_padding_mode:oaep -pkeyopt rsa_oaep_md:sha256 -pkeyopt rsa_mgf1_md:sha256 | openssl enc -base64)
	do
		INFLUX_ENCODEDPW=$INFLUX_ENCODEDPW$line
	done
	
	cat <<EOF
[metrics_influx]
stage = xport_output
type = metrics
file = ${INFLUX_METRICS:-/metrics.json}
datachanneldepth = 1000
output = influx
influx = $INFLUX_URL
database = $INFLUX_DB
workers = ${INFLUX_WORKERS:-10}
username = $INFLUX_USERNAME
password = $INFLUX_ENCODEDPW
EOF

	[ -n "$INFLUX_DUMP" ] && echo "dump = $INFLUX_DUMP"
	[ "$INFLUX_DB_CREATE" = "1" ] && curl -sS "$INFLUX_URL/query" -X POST --data-urlencode "q=CREATE DATABASE $INFLUX_DB" 1>&2
fi

if [ -n "$REPLAY_PIPE" ]; then
	cat <<EOF
[replay_archive]
stage = xport_input
type = replay
file = $REPLAY_PIPE
EOF
	[ -n "$REPLAY_DELAY" ] && echo "delayusec = ${REPLAY_DELAY}"
fi

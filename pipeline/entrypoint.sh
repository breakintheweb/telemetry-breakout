#!/bin/sh
CONF=/etc/pipeline/pipeline.conf
export RSA_KEY=/etc/pipeline_key
[ -f "$RSA_KEY" ] || openssl genrsa -out $RSA_KEY 4096
if [ -f "$REPLAY_ARCHIVE" ]; then
	export REPLAY_PIPE=/tmp/replay.pipe
	rm -f $REPLAY_PIPE
	mkfifo $REPLAY_PIPE
	( echo Replaying dataset...; xzcat $REPLAY_ARCHIVE > $REPLAY_PIPE; rm -f $REPLAY_PIPE; echo Replay completed. ) &
fi
export GODEBUG=netdns=cgo
mkdir -p /etc/pipeline
[ ! -f $CONF -a -x /makeconfig.sh ] && /makeconfig.sh > $CONF
exec /bin/pipeline $DEBUG --config=$CONF --pem=$RSA_KEY --log=


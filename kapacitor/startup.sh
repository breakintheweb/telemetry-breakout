#!/bin/sh
echo $INVENTORY > /inventory

cat >/latency-alert.tick <<EOF
var latency = stream
    |from()
        .database('mdt_realtime')
        .retentionPolicy('autogen')
        .measurement('Cisco-IOS-XR-ip-bfd-oper:bfd/session-details/session-detail')
        .where(lambda: "interface-name"=='$INTERFACE')
        .where(lambda: "status-information__latency-average" > 0)

latency
    |where(lambda: "status-information__latency-average" <= 100000)
    |alert()
        .crit(lambda: "status-information__latency-average" <= 100000)
        .log('/tmp/logs/alerts.log')
        .exec('/telemetry-action.sh', 'enable')

latency
    |where(lambda: "status-information__latency-average" > 100000)
    |alert()
        .crit(lambda: "status-information__latency-average" > 100000)
        .log('/tmp/logs/alerts.log')
        .exec('/telemetry-action.sh', 'disable')
EOF

ansible-playbook -e 'host_key_checking=False' -v -i /inventory /configure-telemetry.yml
( sleep 10 && kapacitor define latency_stream_alert -type stream -tick /latency-alert.tick -dbrp mdt_realtime.autogen && kapacitor enable tasks latency_stream_alert ) &
exec /entrypoint.sh kapacitord

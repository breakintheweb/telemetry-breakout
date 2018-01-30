#!/bin/sh
[ "$1" = "enable" ] && no="no"

[ "$1" != "$(cat /tmp/logs/current_action)" ] && ansible-playbook \
    -e "host_key_checking=False" -e "isis_name=$ISIS" -e "interface_name=$INTERFACE" -e "no=$no" \
    -v -i /inventory /telemetry-action.yml && echo -n "$1" > /tmp/logs/current_action

exit 0
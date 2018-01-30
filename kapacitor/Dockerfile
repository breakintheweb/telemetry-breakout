FROM kapacitor:1.3.3
RUN apt-get update && apt-get -y install ansible && apt-get clean && mkdir /root/.ssh && touch /root/.ssh/known_hosts
ENTRYPOINT []
CMD ["/startup.sh"]
COPY configure-telemetry.yml telemetry-action.yml startup.sh telemetry-action.sh /
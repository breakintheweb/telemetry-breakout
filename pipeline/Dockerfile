FROM alpine:3.6
LABEL maintainer "Steven Barth <stbarth@cisco.com>"
ARG COMMIT=a57e87c59ac220ad7725b6b74c3570243e1a4ac3
RUN apk add --no-cache curl openssl && apk add --no-cache --virtual build-deps build-base go git openssh && \
	git clone https://github.com/cisco/bigmuddy-network-telemetry-pipeline /pipeline && cd /pipeline && \
	git reset --hard $COMMIT && ln -s vendor src && export GOPATH=/pipeline && \
	go build --ldflags '-extldflags "-static"' -o /bin/pipeline && strip /bin/pipeline && \
	cd / && rm -rf /pipeline && apk del build-deps
VOLUME /etc/pipeline
CMD ["/entrypoint.sh"]
COPY entrypoint.sh makeconfig.sh metrics.json /

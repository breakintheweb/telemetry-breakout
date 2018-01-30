{
  "inputs": [{
      "name": "DS_INFLUXDB",
      "type" : "datasource",
      "pluginId" : "influxdb",
      "value" : "InfluxDB"
  }],
  "overwrite": true,
  "dashboard": {
      "__inputs": [
        {
          "name": "DS_INFLUXDB",
          "label": "InfluxDB",
          "description": "",
          "type": "datasource",
          "pluginId": "influxdb",
          "pluginName": "InfluxDB"
        }
      ],
      "__requires": [
        {
          "type": "grafana",
          "id": "grafana",
          "name": "Grafana",
          "version": "4.1.2"
        },
        {
          "type": "panel",
          "id": "graph",
          "name": "Graph",
          "version": ""
        },
        {
          "type": "datasource",
          "id": "influxdb",
          "name": "InfluxDB",
          "version": "1.0.0"
        },
        {
          "type": "panel",
          "id": "singlestat",
          "name": "Singlestat",
          "version": ""
        }
      ],
      "annotations": {
        "list": []
      },
      "editable": true,
      "gnetId": null,
      "graphTooltip": 0,
      "hideControls": false,
      "id": null,
      "links": [],
      "refresh": "10s",
      "rows": [
        {
          "collapse": false,
          "height": 283,
          "panels": [
            {
              "aliasColors": {},
              "bars": false,
              "datasource": "InfluxDB",
              "editable": true,
              "error": false,
              "fill": 1,
              "id": 15,
              "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": false,
                "values": false
              },
              "lines": true,
              "linewidth": 1,
              "links": [],
              "nullPointMode": "connected",
              "percentage": false,
              "pointradius": 2,
              "points": true,
              "renderer": "flot",
              "seriesOverrides": [],
              "span": 12,
              "stack": false,
              "steppedLine": false,
              "targets": [
                {
                  "alias": "GigabitEthernet 0/0/0/0",
                  "dsType": "influxdb",
                  "groupBy": [],
                  "measurement": "Cisco-IOS-XR-ip-bfd-oper:bfd/session-details/session-detail",
                  "policy": "default",
                  "refId": "A",
                  "resultFormat": "time_series",
                  "select": [
                    [
                      {
                        "params": [
                          "status-information__latency-average"
                        ],
                        "type": "field"
                      }
                    ]
                  ],
                  "tags": [
                    {
                      "condition": "AND",
                      "key": "interface-name",
                      "operator": "=",
                      "value": "GigabitEthernet0/0/0/0"
                    }
                  ]
                },
                {
                  "alias": "GigabitEthernet 0/0/0/1",
                  "dsType": "influxdb",
                  "groupBy": [],
                  "measurement": "Cisco-IOS-XR-ip-bfd-oper:bfd/session-details/session-detail",
                  "policy": "default",
                  "refId": "B",
                  "resultFormat": "time_series",
                  "select": [
                    [
                      {
                        "params": [
                          "status-information__latency-average"
                        ],
                        "type": "field"
                      }
                    ]
                  ],
                  "tags": [
                    {
                      "condition": "AND",
                      "key": "interface-name",
                      "operator": "=",
                      "value": "GigabitEthernet0/0/0/1"
                    }
                  ]
                }
              ],
              "thresholds": [],
              "timeFrom": null,
              "timeShift": null,
              "title": "Latency",
              "tooltip": {
                "msResolution": false,
                "shared": true,
                "sort": 0,
                "value_type": "individual"
              },
              "type": "graph",
              "xaxis": {
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
              },
              "yaxes": [
                {
                  "format": "short",
                  "label": "microseconds",
                  "logBase": 10,
                  "max": null,
                  "min": "0",
                  "show": true
                },
                {
                  "format": "short",
                  "label": "",
                  "logBase": 1,
                  "max": null,
                  "min": null,
                  "show": true
                }
              ]
            }
          ],
          "repeat": null,
          "repeatIteration": null,
          "repeatRowId": null,
          "showTitle": false,
          "title": "Dashboard Row",
          "titleSize": "h6"
        }
      ],
      "schemaVersion": 14,
      "style": "dark",
      "tags": [],
      "templating": {
        "list": []
      },
      "time": {
        "from": "now-15m",
        "to": "now"
      },
      "timepicker": {
        "refresh_intervals": [
          "10s"
        ],
        "time_options": [
          "5m",
          "15m",
          "1h",
          "6h",
          "12h",
          "24h",
          "2d",
          "7d",
          "30d"
        ]
      },
      "timezone": "browser",
      "title": "Linklatency",
      "version": 2
    }
}
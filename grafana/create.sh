sudo podman create \
    --name=grafana \
    -e "GF_AUTH_ANONYMOUS_ENABLED=true" \
    -e "GF_AUTH_ANONYMOUS_ORG_NAME=Main Org." \
    -e "GF_AUTH_ANONYMOUS_ORG_ROLE=Viewer" \
    -p 3000:3000 \
    -v /home/pi/grafana/provisioning/:/etc/grafana/provisioning/ \
    -v /home/pi/grafana/dashboards/:/var/lib/grafana/dashboards/ \
    grafana/grafana-arm32v7-linux

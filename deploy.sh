#!/bin/bash

sudo podman pod create \
  --name brew \
  -p 9090:9090,7000:7000

sudo podman create \
  --name onewire-exporter \
  --pod brew \
  --restart always \
  -v /mnt/1wire:/mnt/1wire:ro \
  fenech/onewire-prom-exporter

sudo podman create \
  --name gpio-switch \
  --pod brew \
  --restart always \
  -e GPIOSWITCH_PIN=24 \
  --device /dev/mem \
  --device /dev/gpiomem \
  fenech/gpio-switch

sudo podman create \
  --name prometheus \
  --pod brew \
  --restart always \
  -v /home/pi/prometheus/:/etc/prometheus/:ro \
  prom/prometheus

sudo podman create \
  --name alertmanager \
  --pod brew \
  --restart always \
  -v /home/pi/alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml \
  prom/alertmanager

sudo podman create \
  --name executor \
  --pod brew \
  --restart always \
  -v /home/pi/executor/executor.yml:/etc/executor/executor.yml \
  fenech/prometheus-am-executor -f /etc/executor/executor.yml -v

sudo podman generate systemd -n -f brew

for service in pod-brew container-{onewire-exporter,gpio-switch,prometheus,alertmanager}; do
  sudo mv "$service.service" /usr/lib/systemd/system
  sudo systemctl enable "$service"
done

sudo systemctl start pod-brew

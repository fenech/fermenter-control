./create.sh
sudo podman generate systemd -n -f grafana
sudo mv container-grafana.service /usr/lib/systemd/system
sudo systemctl enable container-grafana
sudo systemctl start container-grafana

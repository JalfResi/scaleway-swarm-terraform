[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// \
  -H tcp://${ip}:2376 \
  --tlsverify \
  --tlscacert=/etc/ssl/certs/ca.pem \
  --tlscert=/etc/ssl/private/server-cert.pem \
  --tlskey=/etc/ssl/private/server-key.pem \
  --storage-driver=overlay2 \
  --dns 8.8.4.4 \
  --dns 8.8.8.8 \
  --log-driver json-file \
  --log-opt max-size=50m \
  --log-opt max-file=10 \
  --experimental=true \
  --metrics-addr ${ip}:9323


data "local_file" "ca-pem" {
  filename = "ca.pem"
}

data "local_file" "server-cert-pem" {
  filename = "server-cert.pem"
}

data "local_file" "server-key-pem" {
  filename = "server-key.pem"
}

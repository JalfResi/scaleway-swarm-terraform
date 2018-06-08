SHELL:=/bin/bash
HOST:=swarm.ourscienceistight.com

init:
	@brew update
	@brew install terraform
	@terraform -v
	@brew install jq
	@jq --version
	@terraform init

generate:
	@echo "Generate CA private and public keys:"
	openssl genrsa -aes256 -out ca-key.pem 4096
	openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem

	@echo "Create a server key and certificate signing request (CSR)"
	@echo "Make sure that “Common Name” matches the hostname you use to connect to Docker:"
	openssl genrsa -out server-key.pem 4096
	openssl req -subj "/CN=${HOST}" -sha256 -new -key server-key.pem -out server.csr

	@echo "Sign the public key with our CA:"
	@echo subjectAltName = DNS:${HOST},IP:10.10.10.20,IP:127.0.0.1 >> extfile.cnf
	@echo extendedKeyUsage = serverAuth >> extfile.cnf

	@echo "Generate the signed certificate:"
	openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem \
	-CAcreateserial -out server-cert.pem -extfile extfile.cnf

	@echo "Create a client key and certificate signing request:"
	openssl genrsa -out key.pem 4096
	openssl req -subj '/CN=client' -new -key key.pem -out client.csr

	@echo extendedKeyUsage = clientAuth >> extfile.cnf
	@echo "Generate the signed certificate:"
	openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem \
  	-CAcreateserial -out cert.pem -extfile extfile.cnf

	rm -v client.csr server.csr
	chmod -v 0400 ca-key.pem key.pem server-key.pem
	chmod -v 0444 ca.pem server-cert.pem cert.pem

reset:
	@terraform destroy -force
	@terraform apply

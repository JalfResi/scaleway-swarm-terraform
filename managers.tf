/*
resource "scaleway_ip" "swarm_manager_ip" {
  count = 1
}
*/

resource "scaleway_server" "swarm_manager" {
  count          = 1
  name           = "${terraform.workspace}-manager-${count.index + 1}"
  image          = "${data.scaleway_image.xenial.id}"
  type           = "${var.manager_instance_type}"
  bootscript     = "${data.scaleway_bootscript.rancher.id}"
  security_group = "${scaleway_security_group.swarm_managers.id}"
  public_ip      = "${var.docker_manager_static_ip}"

  connection {
    type        = "ssh"
    user        = "root"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /etc/systemd/system/docker.service.d",
    ]
  }

  provisioner "file" {
    content     = "${data.local_file.ca-pem.content}"
    destination = "/etc/ssl/certs/ca.pem"
  }

  provisioner "file" {
    content     = "${data.local_file.server-cert-pem.content}"
    destination = "/etc/ssl/private/server-cert.pem"
  }

  provisioner "file" {
    content     = "${data.local_file.server-key-pem.content}"
    destination = "/etc/ssl/private/server-key.pem"
  }

  provisioner "file" {
    content     = "${data.template_file.docker_manager_conf.rendered}"
    destination = "/etc/systemd/system/docker.service.d/docker.conf"
  }

  provisioner "file" {
    source      = "scripts/install-docker-ce.sh"
    destination = "/tmp/install-docker-ce.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-docker-ce.sh",
      "/tmp/install-docker-ce.sh ${var.docker_version}",
      "docker swarm init --advertise-addr ${self.private_ip}",
    ]
  }
}

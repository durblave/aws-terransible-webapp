#Create and bootstrap webserver
resource "aws_instance" "webserver-jenkins" {

  ami                         = data.aws_ssm_parameter.webserver-ami.value
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.webserver-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg-jenkins.id]
  subnet_id                   = aws_subnet.subnet.id



  #Install Jenkins, ansible, terraform, python and ansible
  provisioner "remote-exec" {

    inline = [
            "sudo yum install epel-release java-11-openjdk-devel",
            "yum install -y python3",
            "sudo yum install -y yum-utils",
            "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
            "sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo",
            "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
            "sudo yum upgrade",
            "sudo yum install jenkins",
            "sudo systemctl daemon-reload",
            "sudo yum install -y terraform",
            "sudo yum install -y ansible",
            "sudo yum install -y bash-completion",
            "echo 'alias l='ls -la' >> ~/.bashrc",
            "terraform -install-autocomplete"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "webserver-jenkins"
  }
}

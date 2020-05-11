provider "aws" {
  region  = "eu-central-1"
}

resource "aws_instance" "nginx" {
 ami = "ami-0e342d72b12109f91"
 instance_type = "t2.micro"
 security_groups = ["EC2SecurityGroup"]
 key_name = "my-key"
 tags = {
   Name = "nginx"
 }

 connection {
    type        = "ssh"
    user        = "ubuntu"
    agent       = false
    private_key = "${file("/root/.ssh/my-key.pem")}"
  }

 provisioner "file"{
   source      = "index.html"
   destination = "/home/ubuntu/index.html"
 }

 provisioner "remote-exec" {
    inline = [
     "sudo apt update",
     "sudo apt install -y nginx",
     "sudo cp /home/ubuntu/index.html /var/www/html/index.html",
    ]
 }
}

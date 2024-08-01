variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}
variable "ssh_port" {}

resource "null_resource" "ssh_target" {
    connection {
		type	=	"ssh"
		user	=	var.ssh_user
		host	=	var.ssh_host
		port    =       var.ssh_port
		private_key = file(var.ssh_key)
    }

	 provisioner "file" {
	 source	=	"hosts"
	 destination = "/tmp/hosts"
    }
    
	provisioner "file" {
	 source	=	"interfaces"
	 destination = "/tmp/interfaces"
    }
	        
	provisioner "file" {
	 source	=	"resolv.conf"
	 destination = "/tmp/resolv.conf"
    }

    provisioner "remote-exec" {
	inline= [
    	"sudo cp /tmp/hosts /etc/hosts",
	"sudo hostnamectl set-hostname k8snode1",
	"sudo cp /tmp/resolv.conf /etc/resolv.conf",
	"sudo cp /tmp/interfaces /etc/network/interfaces",
	"sudo shutdown now"

	   ]
    }   
}

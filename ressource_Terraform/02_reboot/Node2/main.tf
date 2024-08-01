variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}
variable "ssh_port" {}
  



resource "null_resource" "ssh_target" {
    connection {
		type	=	"ssh"
		user	=	var.ssh_user
		host	=	var.ssh_host
		port    =   var.ssh_port
		private_key = file(var.ssh_key)
    }

	        
provisioner "remote-exec" {
	inline= [
      "sudo modprobe overlay",
      "sudo modprobe br_netfilter",
      "sudo swapoff -a",
      "sudo sysctl -w net.ipv4.ip_forward=1"
      ]
  }
}

	   
       


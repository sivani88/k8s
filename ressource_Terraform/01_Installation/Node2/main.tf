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

	 provisioner "file" {
	 source	=	"kubeadm-config.yaml"
	 destination = "/tmp/kubeadm-config.yaml"
    }
    
         provisioner "file" {
	 source	=	"kubelet"
	 destination = "/tmp/kubelet"
    } 


	        
provisioner "remote-exec" {
	inline= [
      "sudo modprobe overlay",
      "sudo modprobe br_netfilter",
      "sudo sysctl --system",
      "sudo swapoff -a",
      "sudo apt-get update -y --fix-missing",
      "sudo apt-get install -y software-properties-common curl apt-transport-https ca-certificates --fix-missing",
      "curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg",
      "echo \"deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /\" | sudo tee /etc/apt/sources.list.d/cri-o.list",
      "sudo apt-get update -y",
      "sudo apt-get install -y cri-o",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable crio --now",
      "sudo systemctl start crio.service",
      "sudo mv /tmp/kubeadm-config.yaml .",
      "sudo cp /tmp/ip_forward /proc/sys/net/ipv4/ip_forward",
      "sudo sudo apt-get update -y ",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gpg",
      "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get -y update",
      "sudo apt-get install -y kubelet kubeadm kubectl",
      "sudo apt-mark hold kubelet kubeadm kubectl",
      "sudo sysctl -w net.ipv4.ip_forward=1",	
      "mkdir -p $HOME/.kube",
      "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
      "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
      "sudo systemctl stop kubelet",
      "cd /tmp",
      "VER=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest|grep tag_name | cut -d '\"' -f 4)",
      "wget https://github.com/Mirantis/cri-dockerd/releases/download/$VER/cri-dockerd-$VER-linux-amd64.tar.gz",
      "sudo tar xvf cri-dockerd-$VER-linux-amd64.tar.gz",
      "sudo mv cri-dockerd /usr/local/bin/",
      "wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service",
      "wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket",
      "sudo mv cri-docker.socket cri-docker.service /etc/systemd/system/",
      "sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable cri-docker.service",
      "sudo systemctl enable cri-docker.socket",
      ]
  }
}

	   
       


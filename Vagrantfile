VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "web" do |web|
    # Use the Chef CentOS base image
    web.vm.box = "centos/7"

    # Forward the Vagrant Host port 80 to port 8080 on your workstation.
    web.vm.network "forwarded_port", guest: 80, host: 8080
    web.vm.network "forwarded_port", guest: 433, host: 8433

    # Set up a private IP in the Vagrant Environment. Important for Multi-Host Vagrant deployments.
    web.vm.network "private_network", ip: "192.168.33.10"

    # Define the provision file.
    web.vm.provision :shell, :path => "web-bootstrap.sh"

    # Define a location for your local checkout of your webapp.
    web.vm.synced_folder "~/centos/flaskapp", "/local/www/webapp"
    web.vm.provider "virtualbox" do |vb|
       vb.memory = "2048"
    end
  end
end

nodes = [
  { host: "dev1", box: "ubuntu/xenial64", ip: "10.10.111.111", cpus: 1, memory: 512, gui: false },
  # { host: "dev2", box: "ubuntu/xenial64", ip: "10.10.111.112", cpus: 1, memory: 512, gui: false }
]

domain = "vagrant.test"
subnetMask = "255.255.255.0"
# htmlPath = "/Users/sungwonryu/Desktop/3ee.life/app/public"
appsPath = "apps"
htmlPath = "html"

hostEntries = ""
nodes.each do |node|
  hostEntries << "#{node[:ip]}   #{node[:host]}.#{domain} #{node[:host]}\n"
end

# puts hostEntries

$etchosts = <<SCRIPT
#!/bin/bash
cat > /etc/hosts <<EOF
127.0.0.1     localhost
10.10.10.1    host.#{domain} host
#{hostEntries}
EOF
SCRIPT

Vagrant.configure("2") do |config|

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = false
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  nodes.each do |node|

    config.vm.define node[:host] do |node_config|

      node_config.vm.box = node[:box]

      node_config.vm.network "private_network", ip: node[:ip], netmask: subnetMask

      node_config.vm.hostname = "#{node[:host]}.#{domain}"

      node_config.hostmanager.aliases = "#{node[:host]}"

      node_config.vm.provider "virtualbox" do |vb|
        vb.name = node[:host].to_s
        vb.memory = node[:memory].to_s
        vb.cpus = node[:cpus].to_s
        vb.gui = node[:gui]
      end

      node_config.vm.synced_folder "#{appsPath}/#{node[:host]}/#{htmlPath}", "/var/www/html",
        id: "html",
        owner: "www-data",
        group: "www-data"

      node_config.vm.provision :shell, inline: $etchosts
      node_config.vm.provision :shell, path: "bootstrap.sh"

      if node[:host] == "dev2"
        node_config.vm.synced_folder "repository", "/repository",
          id: "repository",
          owner: "vagrant",
          group: "vagrant"
      end

    end

  end

end

MASTER_IP = '192.168.33.101'
MASTER_HOSTNAME = 'nginx'

MATTERMOST_CLUSTER_IPS = ['192.168.33.104', '192.168.33.105']
MYSQL_REPLICA_IPS = []

MATTERMOST_CLUSTER_PREFIX = 'mattermost'
MYSQL_REPLICA_PREFIX = 'mysql'

MYSQL_ROOT_PASSWORD = 'root'
MATTERMOST_PASSWORD = 'really_secure_password'

Vagrant.configure("2") do |config|
	config.vm.box = "bento/ubuntu-18.04"

	# Generate a hosts file based on the clusters
	hosts = Array.new
	hosts << "#{MASTER_IP}   #{MASTER_HOSTNAME}"

	config.vm.define MASTER_HOSTNAME do |box|
		box.vm.hostname = MASTER_HOSTNAME
		box.vm.network :private_network, ip: MASTER_IP
		box.vm.network "forwarded_port", guest: 3306, host: 23306
		box.vm.network "forwarded_port", guest: 80, host: 8080

		setup_script = File.read('setup.sh')

		box.vm.provision :shell, inline: setup_script

		box.vm.provision :shell, path: 'replication-setup.sh', run: 'always'
	end


	node_ips = MYSQL_REPLICA_IPS

	node_ips.each_with_index do |node_ip, index|
		box_hostname = "#{MYSQL_REPLICA_PREFIX}#{index}"
		hosts << "#{node_ip}   #{box_hostname}"
		
		config.vm.define box_hostname do |box|
			box.vm.hostname = box_hostname
			setup_script = File.read('db_slave_setup.sh')

			setup_script.gsub! '#IP_ADDR#', node_ip
			setup_script.gsub! '#SERVER_ID#', (index+2).to_s()

			box.vm.network "forwarded_port", guest: 3306, host: "#{index+3}3306".to_i()
			box.vm.network :private_network, ip: node_ip
			box.vm.provision :shell, inline: setup_script
		end
	end


	node_ips = MATTERMOST_CLUSTER_IPS

	node_ips.each_with_index do |node_ip, index|
		box_hostname = "#{MATTERMOST_CLUSTER_PREFIX}#{index}"
		hosts << "#{node_ip}   #{box_hostname}"

		config.vm.define box_hostname do |box|
			box.vm.hostname = box_hostname
			setup_script = File.read('mattermost_setup.sh')

			setup_script.gsub! '#IP_ADDRESS#', node_ip

			box.vm.network :private_network, ip: node_ip, bridge: "en0: Wi-Fi (AirPort)"
			box.vm.provision :shell, inline: setup_script

			if index == node_ips.size - 1
				box.vm.provision :shell, path: 'mattermost_finalize.sh'
			end
		end
	end

	hosts_file = File.open('hosts', 'w')
	hosts_file.write(hosts.join("\n"))
	hosts_file.close
end
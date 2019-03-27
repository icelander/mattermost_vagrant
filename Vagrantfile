PROXY_IP = '192.168.33.101'

MATTERMOST_CLUSTER_IPS = ['192.168.33.102', '192.168.33.103']
MYSQL_REPLICA_IPS = ['192.168.33.104, 192.168.33.105']

MATTERMOST_CLUSTER_PREFIX = 'mattermost'
MYSQL_REPLICA_PREFIX = 'mysql'

MYSQL_ROOT_PASSWORD = 'root'
MATTERMOST_PASSWORD = 'really_secure_password'

Vagrant.configure("2") do |config|
	config.vm.box = "bento/ubuntu-18.04"

	config.vm.define 'nginx' do |box|
		box.vm.hostname = 'nginx'
		box.vm.network :private_network, ip: PROXY_IP
		box.vm.network "forwarded_port", guest: 3306, host: 23306
		box.vm.network "forwarded_port", guest: 80, host: 8080

		setup_script = File.read('setup.sh')

		box.vm.provision :shell, inline: setup_script, run: 'once'
	end


	node_ips = MYSQL_REPLICA_IPS

	node_ips.each_with_index do |node_ip, index|
		box_hostname = "#{MYSQL_REPLICA_PREFIX}#{index}"
		

		config.vm.define box_hostname do |box|
			box.vm.hostname = box_hostname
			setup_script = File.read('db_slave_setup.sh')

			setup_script.gsub! '#IP_ADDR#', node_ip
			setup_script.gsub! '#SERVER_ID#', (index+2).to_s()

			box.vm.network "forwarded_port", guest: 3306, host: "#{index+3}3306".to_i()
			box.vm.network :private_network, ip: node_ip
			box.vm.provision :shell, inline: setup_script, run: 'once'
		end
	end


	node_ips = MATTERMOST_CLUSTER_IPS

	node_ips.each_with_index do |node_ip, index|
		box_hostname = "#{MATTERMOST_CLUSTER_PREFIX}#{index}"
		

		config.vm.define box_hostname do |box|
			box.vm.hostname = box_hostname
			setup_script = File.read('mattermost_setup.sh')

			setup_script.gsub! '#IP_ADDR', node_ip

			box.vm.network :private_network, ip: node_ip
			box.vm.provision :shell, inline: setup_script, run: 'once'
		end
	end
end
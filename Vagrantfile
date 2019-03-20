MYSQL_CLUSTER_IPS = ['192.168.33.101', '192.168.33.102']
MATTERMOST_IP = '192.168.33.104'
MYSQL_CLUSTER_PREFIX = 'mysql'

MYSQL_ROOT_PASSWORD = 'mysql_root_password'
MATTERMOST_PASSWORD = 'really_secure_password'

Vagrant.configure("2") do |config|
	config.vm.box = "bento/ubuntu-18.04"

	node_ips = MYSQL_CLUSTER_IPS

	node_ips.each_with_index do |node_ip, index|
		box_hostname = "#{MYSQL_CLUSTER_PREFIX}#{index}"
		
		config.vm.define box_hostname do |box|
			box.vm.hostname = box_hostname

			box.vm.network :private_network, ip: node_ip
			puts "#{index+1}3306".to_i
			box.vm.network "forwarded_port", guest: 3306, host: "#{index+1}3306".to_i

			if index == 0
				setup_script = File.read('master_setup.sh')
			else
				setup_script = File.read('slave_setup.sh')
				setup_script.gsub! '#SERVERID', (index+2).to_s
			end

			# puts setup_script

			box.vm.provision :shell, inline: setup_script, run: 'once'
		end
	end

	config.vm.define 'mattermost' do |box|
		box.vm.hostname = 'mattermost'
		box.vm.network :private_network, ip: MATTERMOST_IP
		box.vm.network "forwarded_port", guest: 8065, host: 8065, host_ip: "127.0.0.1"

		setup_script = File.read('setup.sh')

		box.vm.provision :shell, inline: setup_script, run: 'once'
	end
end
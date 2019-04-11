# -*- mode: ruby -*-
# vi: set ft=ruby :

MATTERMOST_PASSWORD = 'really_secure_password'

Vagrant.configure("2") do |config|
  config.vm.provider 'virtualbox' do |virtualbox, override|
  	config.vm.box = "bento/ubuntu-18.04"
  	config.vm.network "forwarded_port", guest: 8065, host: 8065
  	config.vm.network "forwarded_port", guest: 5432, host: 15432
  	config.vm.hostname = 'mattermost'
  end
  

  # # Specify configuration of AWS provider
  # config.vm.provider 'aws' do |aws, override|
  #     config.vm.box = 'aws'
  #     config.vm.synced_folder ".", "/vagrant", disabled: false, type: 'rsync'
  #     config.vm.hostname = "vagrant-mattermost"

  #     # Read AWS authentication information from environment variables
  #     # TODO: Find a way to store these in a config file. YAML?
  #     aws.access_key_id = 'AKIA2WPOEMKRYRXZA2KG'
  #     aws.secret_access_key = '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'

  #     # Specify region, AMI ID, Instance and security group
  #     aws.region = 'us-east-1'
  #     aws.ami = 'ami-0565af6e282977273' # Ubuntu 16.04
  #     aws.instance_type = 't2.micro'
  #     aws.security_groups = ['default', 'public-ssh', 'launch-wizard-11'] 

  #     # Specify SSH keypair to use
  #     aws.keypair_name = 'paul-vagrant'

  #     # Specify username and private key path
  #     override.ssh.username = 'ubuntu'
  #     override.ssh.private_key_path = '~/.ssh/paul-vagrant.pem'
  # end

  setup_script = File.read('setup.sh')

  setup_script.gsub!('#MATTERMOST_PASSWORD', MATTERMOST_PASSWORD)
 
  config.vm.provision :shell, inline: setup_script, run: 'once'
end

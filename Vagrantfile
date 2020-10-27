# -*- mode: ruby -*-
# vi: set ft=ruby :

MATTERMOST_VERSION = "5.26.2"

MYSQL_ROOT_PASSWORD = 'mysql_root_password'
MATTERMOST_PASSWORD = 'really_secure_password'

ELASTICSEARCH_SERVERS = 3

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

  config.vm.provider :virtualbox do |v|
    v.memory = 4096
    v.cpus = 4
  end

  config.vm.network :private_network, ip: "192.168.1.100"
  config.vm.hostname = 'mattermost'

  # Sets the max map count
  config.vm.provision :shell, inline: 'echo "vm.max_map_count=262144" >> /etc/sysctl.conf; sysctl -p'

  config.vm.provision :docker do |d|
    d.run 'mariadb', 
      image: 'mariadb',
      args: "-p 3306:3306\
             -e MYSQL_ROOT_PASSWORD=#{MYSQL_ROOT_PASSWORD}\
             -e MYSQL_USER=mmuser\
             -e MYSQL_PASSWORD=#{MATTERMOST_PASSWORD}\
             -e MYSQL_DATABASE=mattermost"
  end

  config.vm.provision :docker_compose, 
    yml: "/vagrant/elastic-compose.yml",
    run: "always"


  #   # Save these for later
  #   #
  #   # d.run 'ldap',
  #   #   image: 'rroemhild/test-openldap',
  #   #   args: "-p 389:389"
  #   # d.run 'saml',
  #   #   image: 'jboss/keycloak',
  #   #   args: "-v /vagrant/realm.json:/setup/realm.json\
  #   #          -p 8080:8080\
  #   #          -e KEYCLOAK_USER=admin\
  #   #          -e KEYCLOAK_PASSWORD=secret\
  #   #          -e KEYCLOAK_IMPORT=/setup/realm.json"
  # end

  config.vm.provision :shell,
    path: 'gen_cert.sh'
 
  config.vm.provision :shell,
    path: 'haproxy.sh'

  config.vm.provision 'shell',
    path: "setup.sh",
    args: [MATTERMOST_VERSION, MYSQL_ROOT_PASSWORD, MATTERMOST_PASSWORD]
end

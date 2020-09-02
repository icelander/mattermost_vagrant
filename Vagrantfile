# -*- mode: ruby -*-
# vi: set ft=ruby :

MATTERMOST_VERSION = "5.23.0"

MYSQL_ROOT_PASSWORD = 'mysql_root_password'
MATTERMOST_PASSWORD = 'really_secure_password'

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8065, host: 8065
  config.vm.network "forwarded_port", guest: 3306, host: 13306
  config.vm.network "forwarded_port", guest: 389, host: 2389
  config.vm.hostname = 'mattermost'

  config.vm.provision "docker" do |d|
    d.run 'rroemhild/test-openldap',
      args: "-p 389:389"
    d.run 'mariadb', 
      args: "-p 3306:3306 -e MYSQL_ROOT_PASSWORD=#{MYSQL_ROOT_PASSWORD}"
    d.run 'kristophjunge/test-saml-idp',
      args: "-p 8080:8080 -e SIMPLESAMLPHP_SP_ENTITY_ID=http://app.example.com -e SIMPLESAMLPHP_SP_ASSERTION_CONSUMER_SERVICE=http://localhost/simplesaml/module.php/saml/sp/saml2-acs.php/test-sp -e SIMPLESAMLPHP_SP_SINGLE_LOGOUT_SERVICE=http://localhost/simplesaml/module.php/saml/sp/saml2-logout.php/test-sp"
  end

 
  config.vm.provision 'shell',
    path: "setup.sh",
    args: [MATTERMOST_VERSION, MYSQL_ROOT_PASSWORD, MATTERMOST_PASSWORD]
  
end

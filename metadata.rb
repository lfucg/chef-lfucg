name 'chef-lfucg'
maintainer 'Elton Cheng'
maintainer_email 'elton@apaxsoftware.com'
license 'All Rights Reserved'
description 'Installs/Configures chef-lfucg'
long_description 'Installs/Configures chef-lfucg'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends "apt"
depends "apache2"
depends "python"
depends "database"

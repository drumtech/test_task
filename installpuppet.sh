###Паппет есть?
if wich puppet > /dev/null 2>&1; then
	echo "Puppet installed yet"
	exit 0
fi
###Установка репы паппета
echo "Setup puppet repo"
rpm -ivh http://yum.puppet.com/puppet5-release-el-7.noarch.rpm 2>/dev/null
###Установка паппета
yum group install 'Development Tools' -y
echo "Installing puppet"
yum install -y puppetserver
echo "Puppet installed"

/opt/puppetlabs/bin/puppet module install puppetlabs-postgresql
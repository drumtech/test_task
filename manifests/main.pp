$pack_pip = [ 'psycopg2', 'virtualenv' ]
$pack = [ 'git', 'python-pip', 'nginx', 'uwsgi', 'ansible', 'uwsgi-plugin-python2', 'python-virtualenv', 'python', 'python-devel', 'gcc', 'postgresql-devel' ]
class { 'postgresql::globals':
  manage_package_repo => true,
  version             => '9.6',
} -> 
class { 'postgresql::server':
  listen_addresses => '*',
  manage_pg_hba_conf => true, 
pg_hba_conf_defaults => false,
}

postgresql::server::pg_hba_rule { 'allow application network to access app database':
  description => 'Open up PostgreSQL for access from 192.168.88.0/24',
  type        => 'local',
  database    => 'all',
  user        => 'all',
  address     => '',
  auth_method => 'trust',
}
postgresql::server::pg_hba_rule { 'allow localhost ipv4':
  description => 'Open up PostgreSQL for access from localhost ipv4',
  type        => 'host',
  database    => 'all',
  user        => 'all',
  address     => '127.0.0.1/32',
  auth_method => 'trust',
}
postgresql::server::pg_hba_rule { 'allow localhost ipv6':
  description => 'Open up PostgreSQL for access from localhost ipv6',
  type        => 'host',
  database    => 'all',
  user        => 'all',
  address     => '::1/128',
  auth_method => 'trust',
}
postgresql::server::db { 'askbot':
    user     => 'ask_user',
    password => postgresql_password('ask_user', '123456'),
    require  => Class['postgresql::server'],
}
exec {'yum -y update':
  path => ['/usr/bin/', '/usr/sbin/',],
}
exec {'pip install --upgrade pip':
  path => ['/usr/bin/', '/usr/sbin/',],
  require => Package[$pack_pip],
}
Exec { path => '/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/pgsql-9.6/bin/' }
package { $pack: ensure => 'installed', require => Package['epel-release'], }
package {'epel-release':
  ensure => installed,
  require => Exec['yum -y update'],
}
package { 'setuptools':
  require  => Package[$pack],
  ensure   => latest,
  provider => 'pip',
}
package { $pack_pip:
  require  => Package['setuptools'],
  ensure   => installed,
  provider => 'pip',
}
package { 'django':
  require  => Package[$pack],
  ensure   => latest,
  provider => 'pip',
}
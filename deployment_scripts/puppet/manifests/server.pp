$rabbit_hash = hiera_hash('rabbit_hash', {})
$amqp_port   = hiera('amqp_port')
$amqp_hosts  = hiera('amqp_hosts')

$node_name      = hiera('node_name')
$mysql_hash     = hiera_hash('mysql_hash', {})
$management_vip = hiera('management_vip', undef)
$database_vip   = hiera('database_vip')

$mysql_root_user     = pick($mysql_hash['root_user'], 'root')
$mysql_db_create     = pick($mysql_hash['db_create'], true)
$mysql_root_password = $mysql_hash['root_password']

$db_user     = 'celebrer'
$db_name     = 'celebrer'
$db_password = $mysql_root_password

$db_host          = $database_vip
$db_create        = $mysql_db_create
$db_root_user     = $mysql_root_user
$db_root_password = $mysql_root_password

$read_timeout     = '60'

$allowed_hosts = [ $node_name, 'localhost', '127.0.0.1', '%' ]

validate_string($mysql_root_user)

###

$bind_host = '0.0.0.0'
$bind_port = '8989'

$db_connection = "mysql://${db_user}:${db_password}@${db_host}/${db_name}?read_timeout=${read_timeout}"

###

if $db_create {

  class { 'galera::client':
    custom_setup_class => hiera('mysql_custom_setup_class', 'galera'),
  }

  class { 'celebrer::db::mysql':
    user          => $db_user,
    password      => $db_password,
    dbname        => $db_name,
    allowed_hosts => $allowed_hosts,
  }

  class { 'osnailyfacter::mysql_access':
    db_host     => $db_host,
    db_user     => $db_root_user,
    db_password => $db_root_password,
  }

  Class['galera::client'] ->
    Class['osnailyfacter::mysql_access'] ->
      Class['celebrer::db::mysql']

}

class mysql::config {}
include mysql::config

class mysql::server {}
include mysql::server

class { 'celebrer::db':
  database_connection => $db_connection,
}

class { 'celebrer':
  rabbit_host => split($amqp_hosts, ','),
  rabbit_port => $amqp_port,
  rabbit_user => $rabbit_hash['user'],
  rabbit_password => $rabbit_hash['password'],
  
  service_host => $bind_host,
  service_port => $bind_port,
  
  database_connection => $db_connection,
}

class { 'celebrer::api':
  host => $bind_host,
  port => $bind_port,
}

class { 'celebrer::engine': }

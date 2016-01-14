$rabbit_host = '127.0.0.1'
$rabbit_port = '5672'
$rabbit_user = 'guest'
$rabbit_password = 'guest'

$bind_host = '0.0.0.0'
$bind_port = '8080'

$db_password = 'qwe'
$db_connection = "mysql://celebrer:${db_password}@127.0.0.1/celebrer?charset=utf8"

###

class { 'celebrer::db':
  password => $db_password,
}

class { 'celebrer':
  rabbit_host => $rabbit_host,
  rabbit_port => $rabbit_port,
  rabbit_user => $rabbit_user,
  rabbit_password => $rabbit_password,
  
  service_host => $bind_host,
  service_port => $bind_port,
  
  database_connection => $db_connection,
}

class { 'celebrer::api':
  host => $bind_host,
  port => $bind_port,
}

class { 'celebrer::engine': }

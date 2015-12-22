$rabbit_hash = hiera_hash('rabbit_hash', {})
$amqp_port   = hiera('amqp_port')
$amqp_hosts  = hiera('amqp_hosts')

###

class { '::celebrer::agent':
  rabbit_host => split($amqp_hosts, ','),
  rabbit_port => $amqp_port,
  rabbit_user => $rabbit_hash['user'],
  rabbit_password => $rabbit_hash['password'],
}
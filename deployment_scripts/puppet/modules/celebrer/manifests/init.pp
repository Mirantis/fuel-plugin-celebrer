class celebrer (
  $package_ensure          = 'present',
  $verbose                 = true,
  $debug                   = true,
  $rabbit_host             = '127.0.0.1',
  $rabbit_port             = '5672',
  $rabbit_user             = 'guest',
  $rabbit_password         = 'guest',
  $database_connection     = undef,
  $database_max_retries    = undef,
  $database_idle_timeout   = undef,
  $database_min_pool_size  = undef,
  $database_max_pool_size  = undef,
  $database_max_retries    = undef,
  $database_retry_interval = undef,
  $database_max_overflow   = undef,
  $sync_db                 = true,
  $reports_dir             = '/var/cache/celebrer',
) {

  include ::celebrer::params
  include ::celebrer::db

  package { 'celebrer-common':
    ensure => $package_ensure,
    name   => $::celebrer::params::common_package_name,
    tag    => ['openstack', 'celebrer-package'],
  }

  celebrer_config {
    'DEFAULT/debug':                          value => $debug;
    'DEFAULT/verbose':                        value => $verbose;

    'oslo_messaging_rabbit/rabbit_userid' :   value => $rabbit_user;
    'oslo_messaging_rabbit/rabbit_password' : value => $rabbit_password;
    'oslo_messaging_rabbit/rabbit_hosts' :    value => $rabbit_host;
    'oslo_messaging_rabbit/rabbit_port' :     value => $rabbit_port;

    'celebrer/reports_dir':                   value => $reports_dir;
  }

  if $sync_db {
    include ::celebrer::db::sync
  }
}

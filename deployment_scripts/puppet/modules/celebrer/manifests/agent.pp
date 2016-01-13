# == Class: celebrer::agent
#
#  celebrer agent package & service
#
# === Parameters
#
# [*manage_service*]
#  (Optional) Should the service be enabled
#  Defaults to true
#
# [*enabled*]
#  (Optional) Whether the service should be managed by Puppet
#  Defaults to true
#
# [*package_ensure*]
#  (Optional) Ensure state for package
#  Defaults to 'present'
#
class celebrer::agent(
  $manage_service  = true,
  $enabled         = true,
  $package_ensure  = 'present',
  $verbose         = true,
  $debug           = true,
  $rabbit_host     = '127.0.0.1',
  $rabbit_port     = '5672',
  $rabbit_user     = 'guest',
  $rabbit_password = 'guest',
) {

  include ::celebrer::params

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  celebrer_agent_config {
    'DEFAULT/debug':                           value => $debug;
    'DEFAULT/verbose':                         value => $verbose;

    'oslo_messaging_rabbit/rabbit_userid' :    value => $rabbit_user;
    'oslo_messaging_rabbit/rabbit_password' :  value => $rabbit_password;
    'oslo_messaging_rabbit/rabbit_hosts' :     value => $rabbit_host;
    'oslo_messaging_rabbit/rabbit_port' :      value => $rabbit_port;
  }

  package { 'celebreragent':
    ensure => $package_ensure,
    name   => $::celebrer::params::agent_package_name,
  }

  service { 'celebreragent':
    ensure  => $service_ensure,
    name    => $::celebrer::params::agent_service_name,
    enable  => $enabled,
    require => Package['celebreragent'],
  }

  Celebrer_agent_config<||> ~> Service['celebreragent']
  Package['celebreragent'] ~> Service['celebreragent']
}

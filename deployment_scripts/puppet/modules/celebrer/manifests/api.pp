# == Class: celebrer::api
#
#  celebrer api package & service
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
# [*host*]
#  (Optional) Host on which celebrer api should listen
#  Defaults to $::os_service_default.
#
# [*port*]
#  (Optional) Port on which celebrer api should listen
#  Defaults to $::os_service_default.
#
# [*sync_db*]
#  (Optional) Whether to sync database
#  Defaults to true
#
class celebrer::api(
  $manage_service = true,
  $enabled        = true,
  $package_ensure = 'present',
  $host           = '127.0.0.1',
  $port           = '8080',
  $sync_db        = true,
) {

  include ::celebrer::params

  Celebrer_config<||> ~> Service['celebrer-api']
  Exec['celebrer-dbmanage'] -> Service['celebrer-api']

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  celebrer_config {
    'DEFAULT/bind_host': value => $host;
    'DEFAULT/bind_port': value => $port;
  }

  package { 'celebrer-api':
    ensure => $package_ensure,
    name   => $::celebrer::params::api_package_name,
  }

  service { 'celebrer-api':
    ensure  => $service_ensure,
    name    => $::celebrer::params::api_service_name,
    enable  => $enabled,
    require => Package['celebrer-api'],
  }

  Package['celebrer-api'] ~> Service['celebrer-api']
  Murano_paste_ini_config<||> ~> Service['celebrer-api']

  if $sync_db {
    include ::celebrer::db::sync
  }
}

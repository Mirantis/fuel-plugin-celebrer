# == Class: celebrer::engine
#
#  celebrer engine package & service
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
# [*sync_db*]
#  (Optional) Whether to sync database
#  Defaults to true
#
class celebrer::engine(
  $manage_service = true,
  $enabled        = true,
  $package_ensure = 'present',
  $sync_db        = true,
) {

  include ::celebrer::params

  Celebrer_config<||> ~> Service['celebrer-engine']
  Exec['celebrer-dbmanage'] -> Service['celebrer-engine']

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  package { 'celebrer-engine':
    ensure => $package_ensure,
    name   => $::celebrer::params::engine_package_name,
  }

  service { 'celebrer-engine':
    ensure  => $service_ensure,
    name    => $::celebrer::params::engine_service_name,
    enable  => $enabled,
    require => Package['celebrer-engine'],
  }

  Package['celebrer-engine'] ~> Service['celebrer-engine']

  if $sync_db {
    include ::celebrer::db::sync
  }
}

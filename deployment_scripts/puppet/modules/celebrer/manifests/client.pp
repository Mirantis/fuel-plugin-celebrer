# == Class: celebrer::client
#
#  celebrer client package
#
# === Parameters
#
# [*package_ensure*]
#  (Optional) Ensure state for package
#  Defaults to 'present'
#
class celebrer::client(
  $package_ensure = 'present',
) {

  include ::celebrer::params

  package { 'python-celebrerclient':
    ensure => $package_ensure,
    name   => $::celebrer::params::pythonclient_package_name,
    tag    => ['openstack', 'celebrer-packages'],
  }

}

# == Class: celebrer::dashboard
#
#  celebrer dashboard package
#
# === Parameters
#
# [*package_ensure*]
#  (Optional) Ensure state for package
#  Defaults to 'present'
#
class celebrer::dashboard(
  $package_ensure = 'present',
) {

  include ::celebrer::params

  package { 'python-celebrer-dashboard':
    ensure => $package_ensure,
    name   => $::celebrer::params::dashboard_package_name,
    tag    => ['openstack', 'celebrer-packages'],
  }

}

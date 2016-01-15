# == Class: celebrer::params
#
# Parameters for puppet-celebrer
#
class celebrer::params {
  $dbmanage_command = 'celebrer-db-manage --config-file /etc/celebrer/celebrer.conf'

  case $::osfamily {
    'RedHat': {
      # package names
      $common_package_name = "celebrer-common"
      $agent_package_name  = "celebrer-agent"
      $engine_package_name = "celebrer-engine"
      $api_package_name    = "celebrer-api"
      # service names
      $agent_service_name  = "celebrer-agent"
      $engine_service_name = "celebrer-engine"
      $api_service_name    = "celebrer-api"
    }
    'Debian': {
      # package names
      $common_package_name = "celebrer-common"
      $agent_package_name  = "celebrer-agent"
      $engine_package_name = "celebrer-engine"
      $api_package_name    = "celebrer-api"
      # service names
      $agent_service_name  = "celebrer-agent"
      $engine_service_name = "celebrer-engine"
      $api_service_name    = "celebrer-api"
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}")
    }
  }
}

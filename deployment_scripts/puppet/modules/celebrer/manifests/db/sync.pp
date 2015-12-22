#
# Class to execute celebrer dbsync
#
class celebrer::db::sync {

  include ::celebrer::params

  Package <| title == 'celebrer-common' |> ~> Exec['celebrer-dbmanage']
  Exec['celebrer-dbmanage'] ~> Service <| tag == 'celebrer-service' |>

  Murano_config <| title == 'database/connection' |> ~> Exec['celebrer-dbmanage']

  exec { 'celebrer-dbmanage':
    command     => $::celebrer::params::dbmanage_command,
    path        => '/usr/bin',
    user        => 'celebrer',
    refreshonly => true,
    logoutput   => on_failure,
  }

}

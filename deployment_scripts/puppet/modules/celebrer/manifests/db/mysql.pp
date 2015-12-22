# == Class: celebrer::db::mysql
#
# The celebrer::db::mysql class creates a MySQL database for celebrer.
# It must be used on the MySQL server.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'celebrer'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'celebrer'.
#
# [*host*]
#   (Optional) The default source host user is allowed to connect from.
#   Defaults to '127.0.0.1'
#
# [*allowed_hosts*]
#   (Optional) Other hosts the user is allowed to connect from.
#   Defaults to 'undef'.
#
# [*charset*]
#   (Optional) The database charset.
#   Defaults to 'utf8'.
#
# [*collate*]
#   (Optional) Charset collate of celebrer database.
#    Defaults to 'utf8_general_ci'.
#
class celebrer::db::mysql(
  $password,
  $dbname        = 'celebrer',
  $user          = 'celebrer',
  $host          = '127.0.0.1',
  $allowed_hosts = undef,
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
) {

  validate_string($password)

  ::openstacklib::db::mysql{ 'celebrer':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  ::Openstacklib::Db::Mysql['celebrer'] ~> Exec<| title == 'celebrer-dbmanage' |>
}

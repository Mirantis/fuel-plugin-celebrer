# == Class: celebrer::keystone::auth
#
# Configures celebrer service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for murano user.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to the value of auth_name.
#
# [*auth_name*]
#   (Optional) Username for celebrer service.
#   Defaults to 'celebrer'.
#
# [*email*]
#   (Optional) Email for celebrer user.
#   Defaults to 'celebrer@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for celebrer user.
#   Defaults to 'services'.
#
# [*configure_endpoint*]
#   (Optional) Should celebrer endpoint be configured?
#   Defaults to 'true'.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'coverage-collector'.
#
# [*service_description*]
#   (Optional) Description of service.
#   Defaults to 'Celebrer Coverage Collector'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:8989
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:8989
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:8989
#   This url should *not* contain any trailing '/'.
#
# === Examples
#
#  class { 'celebrer::keystone::auth':
#    password     => 'secret',
#    public_url   => 'https://10.0.0.10:8989',
#    internal_url => 'https://10.0.0.11:8989',
#    admin_url    => 'https://10.0.0.11:8989',
#  }
#
class celebrer::keystone::auth(
  $password,
  $service_name        = undef,
  $auth_name           = 'celebrer',
  $email               = 'celebrer@localhost',
  $tenant              = 'services',
  $service_type        = 'coverage-collector',
  $service_description = 'Celebrer Coverage Collector',
  $configure_endpoint  = true,
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:8989',
  $admin_url           = 'http://127.0.0.1:8989',
  $internal_url        = 'http://127.0.0.1:8989',
) {

  $real_service_name = pick($service_name, $auth_name)

  keystone::resource::service_identity { $real_service_name:
    configure_user      => true,
    configure_user_role => true,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }
}

notice('MODULAR: puppet/manifests/keystone.pp')

$celebrer_hash     = hiera_hash('celebrer_hash', {})
$public_ip         = hiera('public_vip')
$management_ip     = hiera('management_vip')
$region            = hiera('region', 'RegionOne')
$public_ssl_hash   = hiera('public_ssl')
$ssl_hash          = hiera_hash('use_ssl', {})

$public_protocol   = get_ssl_property($ssl_hash, $public_ssl_hash, 'celebrer', 'public', 'protocol', 'http')
$public_address    = get_ssl_property($ssl_hash, $public_ssl_hash, 'celebrer', 'public', 'hostname', [$public_ip])

$internal_protocol = get_ssl_property($ssl_hash, {}, 'celebrer', 'internal', 'protocol', 'http')
$internal_address  = get_ssl_property($ssl_hash, {}, 'celebrer', 'internal', 'hostname', [$management_ip])

$admin_protocol    = get_ssl_property($ssl_hash, {}, 'celebrer', 'admin', 'protocol', 'http')
$admin_address     = get_ssl_property($ssl_hash, {}, 'celebrer', 'admin', 'hostname', [$management_ip])

$api_bind_port     = '8989'
$tenant            = pick($celebrer_hash['tenant'], 'services')
$public_url        = "${public_protocol}://${public_address}:${api_bind_port}"
$internal_url      = "${internal_protocol}://${internal_address}:${api_bind_port}"
$admin_url         = "${admin_protocol}://${admin_address}:${api_bind_port}"

#################################################################

class { 'celebrer::keystone::auth':
  password     => $celebrer_hash['user_password'],
  service_type => 'coverage_collector',
  region       => $region,
  tenant       => $tenant,
  public_url   => $public_url,
  internal_url => $internal_url,
  admin_url    => $admin_url,
}

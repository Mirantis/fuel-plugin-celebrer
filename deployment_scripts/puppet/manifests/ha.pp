$public_ssl_hash    = hiera_hash('public_ssl', {})
$ssl_hash           = hiera_hash('use_ssl', {})

$public_ssl         = get_ssl_property($ssl_hash, $public_ssl_hash, 'celebrer', 'public', 'usage', false)
$public_ssl_path    = get_ssl_property($ssl_hash, $public_ssl_hash, 'celebrer', 'public', 'path', [''])

$internal_ssl       = get_ssl_property($ssl_hash, {}, 'celebrer', 'internal', 'usage', false)
$internal_ssl_path  = get_ssl_property($ssl_hash, {}, 'celebrer', 'internal', 'path', [''])

$external_lb        = hiera('external_lb', false)

if (!$external_lb) {
  # We temporarily use Glance credentials. Fixme!
  $celebrer_address_map  = get_node_to_ipaddr_map_by_network_role(hiera_hash('glance_nodes'), 'glance/api')
  $server_names        = hiera_array('celebrer_names', keys($celebrer_address_map))
  $ipaddresses         = hiera_array('celebrer_ipaddresses', values($celebrer_address_map))
  $public_virtual_ip   = hiera('public_vip')
  $internal_virtual_ip = hiera('management_vip')

  # defaults for any haproxy_service within this class
  Openstack::Ha::Haproxy_service {
    internal_virtual_ip => $internal_virtual_ip,
    ipaddresses         => $ipaddresses,
    public_virtual_ip   => $public_virtual_ip,
    server_names        => $server_names,
    public              => true,
  }

  openstack::ha::haproxy_service { 'celebrer-api':
    order                  => '666',
    listen_port            => 8989,
    public_ssl             => $public_ssl,
    public_ssl_path        => $public_ssl_path,
    internal_ssl           => $internal_ssl,
    internal_ssl_path      => $internal_ssl_path,
    require_service        => 'celebrer_api',
    haproxy_config_options => {
      'http-request' => 'set-header X-Forwarded-Proto https if { ssl_fc }',
    },
  }
}

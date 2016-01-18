notice('MODULAR: puppet/manifests/ha.pp')

$network_metadata  = hiera_hash('network_metadata')
$public_ssl_hash   = hiera('public_ssl')
$ssl_hash          = hiera_hash('use_ssl', {})

$public_ssl        = get_ssl_property($ssl_hash, $public_ssl_hash, 'celebrer', 'public', 'usage', false)
$public_ssl_path   = get_ssl_property($ssl_hash, $public_ssl_hash, 'celebrer', 'public', 'path', [''])

$internal_ssl      = get_ssl_property($ssl_hash, {}, 'glance', 'internal', 'usage', false)
$internal_ssl_path = get_ssl_property($ssl_hash, {}, 'glance', 'internal', 'path', [''])

$glances_address_map = get_node_to_ipaddr_map_by_network_role(get_nodes_hash_by_roles($network_metadata, ['primary-controller', 'controller']), 'mgmt/vip')

$external_lb = hiera('external_lb', false)

if (!$external_lb) {
  $server_names        = hiera_array('celebrer_names', keys($celebrer_address_map))
  $ipaddresses         = hiera_array('celebrer_ipaddresses', values($celebrer_address_map))
  $public_virtual_ip   = hiera('public_vip')
  $internal_virtual_ip = hiera('management_vip')

  class { '::openstack::ha::celebrer':
    internal_virtual_ip => $internal_virtual_ip,
    ipaddresses         => $ipaddresses,
    public_virtual_ip   => $public_virtual_ip,
    server_names        => $server_names,
    public_ssl          => $public_ssl,
    public_ssl_path     => $public_ssl_path,
    internal_ssl        => $internal_ssl,
    internal_ssl_path   => $internal_ssl_path,
  }
}

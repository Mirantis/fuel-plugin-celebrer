Puppet::Type.type(:celebrer_paste_ini_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/celebrer/celebrer-paste.ini'
  end

end

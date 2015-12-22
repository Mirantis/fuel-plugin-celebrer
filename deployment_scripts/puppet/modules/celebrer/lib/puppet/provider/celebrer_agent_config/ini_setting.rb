Puppet::Type.type(:celebrer_agent_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/celebrer/celebrer-agent.conf'
  end

end

# some generic installation boilerplate, used by all platforms
class lxc::install (
  $container_dir   = $lxc::defaults::container_dir,
){
  file { '/etc/lxc':
    ensure         => directory,
    require        => Package['lxc'],
  }

  # we need that for some state files
  file { [$container_dir, '/etc/lxc/puppet']:
    ensure         => 'directory',
    require        => File['/etc/lxc'],
  }
  
  file {'/etc/lxc/lxc.conf':
    content        => "# PUPPET module ${module_name}\nlxc.cgroup.pattern = lxc/%n\nlxc.lxcpath = ${lxc::defaults::container_dir}\n",
    require        => File['/etc/lxc'],
  }
}
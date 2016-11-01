class lxc (
    $containers                             = {},
    $more_facts                             = undef,
    $manage_service                         = false,
    $container_dir                          = '/srv/lxc',
    $mac_prefix                             = '00:16:3e',
    $use_backports                          = true,
    $templates_dir                          = '/usr/share/lxc/templates',
    $template                               = 'lxc-download', 
    $lxc_includes                           = ['/usr/share/lxc/config/debian.common.conf', '/usr/share/lxc/config/debian.userns.conf'],
    $lxc_arch                               = "x86_64",
    $lxc_cgroup_memory_limit_in_bytes       = '512M',
    $lxc_cgroup_memory_memsw_limit_in_bytes = '1024M',
    $lxc_cgroup_devices_deny                = 'a',
    $lxc_cgroup_devices_allow_mknod_block   = true,
    $lxc_cgroup_devices_allow_mknod_char    = true,
    $lxc_cgroup_devices_allow_devnull       = true,
    $lxc_cgroup_devices_allow_devzero       = true,
    $lxc_cgroup_devices_allow_consoles      = true,
    $lxc_cgroup_devices_allow_random        = true,
    $lxc_cgroup_devices_allow_urandom       = true,
    $lxc_cgroup_devices_allow_pts           = true,
    $lxc_cgroup_devices_allow_rtc           = true,
    $lxc_cgroup_devices_allow_fuse          = false,
    $lxc_cgroup_devices_allow_tun           = false,
    $lxc_cgroup_devices_allow_full          = true,
    $lxc_cgroup_devices_allow_hpet          = false,
    $lxc_cgroup_devices_allow_kvm           = false,
    $lxc_cgroup_devices_allow_additional    = [],
    $download_template_distribution         = 'debian',
    $download_template_release              = 'jessie',
    $download_template_architecture         = 'amd64',
    $download_template_variant              = 'default',
    $download_template_server               = 'images.linuxcontainers.org',
) {
  class {'lxc::defaults':
    manage_service                         => $manage_service,
    container_dir                          => $container_dir,
    mac_prefix                             => $mac_prefix,
    use_backports                          => $use_backports,
    templates_dir                          => $templates_dir,
    template                               => $template,
    lxc_includes                           => $lxc_includes,
    lxc_arch                               => $lxc_arch,
    lxc_cgroup_memory_limit_in_bytes       => $lxc_cgroup_memory_limit_in_bytes,
    lxc_cgroup_memory_memsw_limit_in_bytes => $lxc_cgroup_memory_memsw_limit_in_bytes,
    lxc_cgroup_devices_deny                => $lxc_cgroup_devices_deny,
    lxc_cgroup_devices_allow_mknod_block   => $lxc_cgroup_devices_allow_mknod_block,
    lxc_cgroup_devices_allow_mknod_char    => $lxc_cgroup_devices_allow_mknod_char,
    lxc_cgroup_devices_allow_devnull       => $lxc_cgroup_devices_allow_devnull,
    lxc_cgroup_devices_allow_devzero       => $lxc_cgroup_devices_allow_devzero,
    lxc_cgroup_devices_allow_consoles      => $lxc_cgroup_devices_allow_consoles,
    lxc_cgroup_devices_allow_random        => $lxc_cgroup_devices_allow_random,
    lxc_cgroup_devices_allow_urandom       => $lxc_cgroup_devices_allow_urandom,
    lxc_cgroup_devices_allow_pts           => $lxc_cgroup_devices_allow_pts,
    lxc_cgroup_devices_allow_rtc           => $lxc_cgroup_devices_allow_rtc,
    lxc_cgroup_devices_allow_fuse          => $lxc_cgroup_devices_allow_fuse,
    lxc_cgroup_devices_allow_tun           => $lxc_cgroup_devices_allow_tun,
    lxc_cgroup_devices_allow_full          => $lxc_cgroup_devices_allow_full,
    lxc_cgroup_devices_allow_hpet          => $lxc_cgroup_devices_allow_hpet ,
    lxc_cgroup_devices_allow_kvm           => $lxc_cgroup_devices_allow_kvm,
    lxc_cgroup_devices_allow_additional    => $lxc_cgroup_devices_allow_additional,
    download_template_distribution         => $download_template_distribution,
    download_template_release              => $download_template_release,
    download_template_architecture         => $download_template_architecture,
    download_template_variant              => $download_template_variant,
    download_template_server               => $download_template_server,
  }

  # platform common
  include lxc::install

  notice ("container dir is ${container_dir}, ::lxc::defaults::container_dir is ${lxc::defaults::container_dir}, lxc::defaults::download_template_release is ${lxc::defaults::download_template_release}")
  case $::osfamily {
    'Debian': {
      include lxc::install::debian
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }

  # this is a hook for puppet frameworks that prefer to generate resources iteratively
  create_resources('lxc::container', $containers, { more_facts => $more_facts })
}

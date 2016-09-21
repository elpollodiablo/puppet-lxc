class lxc::unprivileged (
  $containers                             = {},
  $more_facts                             = undef,
  $user                                   = 'lxc_u',
  $group                                  = 'lxc_u',
  $uid                                    = 10000,
  $gid                                    = 10000,
  $home                                   = '/srv/lxc_unprivileged',
  $shell                                  = '/bin/sh',
  $password                               = '!!',
	$create_user_group                      = true,
	$create_autostart_crontab               = true,
  $container_dir                          = '/srv/lxc_unprivileged',
  $lxc_includes                           = $lxc::defaults::lxc_includes,
  $lxc_arch                               = $lxc::defaults::lxc_arch,
  $lxc_cgroup_memory_limit_in_bytes       = $lxc::defaults::lxc_cgroup_memory_limit_in_bytes,
  $lxc_cgroup_memory_memsw_limit_in_bytes = $lxc::defaults::lxc_cgroup_memory_memsw_limit_in_bytes,
  $lxc_cgroup_devices_deny                = $lxc::defaults::lxc_cgroup_devices_deny,
  $lxc_cgroup_devices_allow_mknod_block   = $lxc::defaults::lxc_cgroup_devices_allow_mknod_block,
  $lxc_cgroup_devices_allow_mknod_char    = $lxc::defaults::lxc_cgroup_devices_allow_mknod_char,
  $lxc_cgroup_devices_allow_devnull       = $lxc::defaults::lxc_cgroup_devices_allow_devnull,
  $lxc_cgroup_devices_allow_devzero       = $lxc::defaults::lxc_cgroup_devices_allow_devzero,
  $lxc_cgroup_devices_allow_consoles      = $lxc::defaults::lxc_cgroup_devices_allow_consoles,
  $lxc_cgroup_devices_allow_random        = $lxc::defaults::lxc_cgroup_devices_allow_random,
  $lxc_cgroup_devices_allow_urandom       = $lxc::defaults::lxc_cgroup_devices_allow_urandom,
  $lxc_cgroup_devices_allow_pts           = $lxc::defaults::lxc_cgroup_devices_allow_pts,
  $lxc_cgroup_devices_allow_rtc           = $lxc::defaults::lxc_cgroup_devices_allow_rtc,
  $lxc_cgroup_devices_allow_fuse          = $lxc::defaults::lxc_cgroup_devices_allow_fuse,
  $lxc_cgroup_devices_allow_tun           = $lxc::defaults::lxc_cgroup_devices_allow_tun,
  $lxc_cgroup_devices_allow_full          = $lxc::defaults::lxc_cgroup_devices_allow_full,
  $lxc_cgroup_devices_allow_hpet          = $lxc::defaults::lxc_cgroup_devices_allow_hpet,
  $lxc_cgroup_devices_allow_kvm           = $lxc::defaults::lxc_cgroup_devices_allow_kvm,
  $lxc_cgroup_devices_allow_additional    = $lxc::defaults::lxc_cgroup_devices_allow_additional,
  $mac_prefix                             = $lxc::defaults::mac_prefix,
  $template                               = $lxc::defaults::template,
  $templates_dir                          = $lxc::defaults::templates_dir,
  $download_template_distribution         = $lxc::defaults::download_template_distribution,
  $download_template_release              = $lxc::defaults::download_template_release,
  $download_template_architecture         = $lxc::defaults::download_template_architecture,
  $download_template_variant              = $lxc::defaults::download_template_variant,
  $download_template_server               = $lxc::defaults::download_template_server,
  $use_jessie_pam_patch                   = true,
) {
  class {'lxc::unprivileged::defaults':
    user                                   => $user,
    group                                  => $group,
    uid                                    => $uid,
    gid                                    => $gid,
    home                                   => $home,
    shell                                  => $shell,
    password                               => $password,
    template                               => $template,
    templates_dir                          => $templates_dir,
    container_dir                          => $container_dir,
    use_backports                          => $use_backports,
  	create_user_group                      => $create_user_group,
  	create_autostart_crontab               => $create_autostart_crontab,
    lxc_includes                           => $lxc_includes,
    lxc_arch                               => $lxc_arch,
    mac_prefix                             => $mac_prefix,
    lxc_cgroup_memory_limit_in_bytes       => $lxc::defaults::lxc_cgroup_memory_limit_in_bytes,
    lxc_cgroup_memory_memsw_limit_in_bytes => $lxc::defaults::lxc_cgroup_memory_memsw_limit_in_bytes,
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
    use_jessie_pam_patch                  => $use_jessie_pam_patch,
  }
  if ($create_autostart_crontab) {
    cron { 'lxc autostart for ${user}:${group}':
      ensure       => present,
      command      => '/usr/bin/lxc-autostart',
      special      => 'reboot',
      user         => $user,
      require      => User[$user],
    }
  }
  if ($create_user_group) {
    lxc::unprivileged::user_and_group {$user:
      user         => $user,
      group        => $group,
      uid          => $uid,
      gid          => $gid,
      home         => $home,
    }
  }
  case $::osfamily {
    'Debian': {
      include lxc::install::debian
      include lxc::unprivileged::install::debian
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
  create_resources('lxc::unprivileged::container', $containers, { more_facts => $more_facts })
}

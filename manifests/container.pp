define lxc::container(
  $utsname                 = $name,
  $template                = $lxc::defaults::template,
  $network_devices         = {},
  $network_string          = undef,
  $network_devices_string  = undef,
  $ensure                  = 'present',
  $enable                  = true,
  $mem_limit               = '512M',
  $mem_plus_swap_limit     = '1024M',
  $more_facts              = undef,
  $start_on_creation       = true,
  $start_on_boot           = true,
  $backing_store           = 'dir',
  $snapshot                = false,
  $unprivileged            = false,
	$unprivileged_user       = $lxc::unprivileged::defaults::user,
	$unprivileged_group      = $lxc::unprivileged::defaults::group,
  $unprivileged_home       = $lxc::unprivileged::defaults::home,
  $unprivileged_container_dir = $lxc::unprivileged::defaults::container_dir,
  $template_extra_options          = $lxc::unprivileged::defaults::template_extra_options,
  
  $download_template_distribution  = $lxc::defaults::download_template_distribution,
  $download_template_release       = $lxc::defaults::download_template_release,
  $download_template_architecture  = $lxc::defaults::download_template_architecture,
  $download_template_variant       = $lxc::defaults::download_template_variant,
  $download_template_server        = $lxc::defaults::download_template_server,
  
  $lxc_includes                    = $lxc::defaults::lxc_includes,
  $lxc_arch                        = $lxc::defaults::lxc_arch,
  
  $container_dir           = $lxc::defaults::container_dir,
  $templates_dir           = $lxc::defaults::templates_dir,
  $lxc_cgroup_devices_deny = $lxc::defaults::lxc_cgroup_devices_deny,
  $lxc_cgroup_devices_allow_mknod_block = $lxc::defaults::lxc_cgroup_devices_allow_mknod_block,
  $lxc_cgroup_devices_allow_mknod_char = $lxc::defaults::lxc_cgroup_devices_allow_mknod_char,
  $lxc_cgroup_devices_allow_devnull = $lxc::defaults::lxc_cgroup_devices_allow_devnull,
  $lxc_cgroup_devices_allow_devzero = $lxc::defaults::lxc_cgroup_devices_allow_devzero,
  $lxc_cgroup_devices_allow_consoles = $lxc::defaults::lxc_cgroup_devices_allow_consoles,
  $lxc_cgroup_devices_allow_random = $lxc::defaults::lxc_cgroup_devices_allow_random,
  $lxc_cgroup_devices_allow_urandom = $lxc::defaults::lxc_cgroup_devices_allow_urandom,
  $lxc_cgroup_devices_allow_pts = $lxc::defaults::lxc_cgroup_devices_allow_pts,
  $lxc_cgroup_devices_allow_rtc = $lxc::defaults::lxc_cgroup_devices_allow_rtc,
  $lxc_cgroup_devices_allow_fuse = $lxc::defaults::lxc_cgroup_devices_allow_fuse,
  $lxc_cgroup_devices_allow_tun = $lxc::defaults::lxc_cgroup_devices_allow_tun,
  $lxc_cgroup_devices_allow_full = $lxc::defaults::lxc_cgroup_devices_allow_full,
  $lxc_cgroup_devices_allow_hpet = $lxc::defaults::lxc_cgroup_devices_allow_hpet,
  $lxc_cgroup_devices_allow_kvm = $lxc::defaults::lxc_cgroup_devices_allow_kvm,
  $lxc_cgroup_devices_allow_additional = $lxc::defaults::lxc_cgroup_devices_allow_additional,
  $lxc_cgroup_memory_limit_in_bytes = $lxc::defaults::lxc_cgroup_memory_limit_in_bytes,
  $lxc_cgroup_memory_memsw_limit_in_bytes = $lxc::defaults::lxc_cgroup_memory_memsw_limit_in_bytes,
) {
  if $unprivileged {
    $my_container_dir = $unprivileged_container_dir
  } else {
    $my_container_dir = $container_dir
  }

  # lxc configuration file
  $config_file  = "${my_container_dir}/${utsname}/config"

  # lxc commands
  $lxc_destroystop  = "/usr/bin/lxc-stop -P ${my_container_dir} -n ${utsname} -W -k || true"
  $lxc_start        = "/usr/bin/lxc-start -P ${my_container_dir} -n ${utsname} -d"
  $lxc_destroy      = "/usr/bin/lxc-destroy -P ${my_container_dir} -n ${utsname} || true"
  $lxc_info         = "/usr/bin/lxc-info -P ${my_container_dir} -n ${utsname}"
  $lxc_shutdown     = "/usr/bin/lxc-stop -P ${my_container_dir} -n ${utsname} -t 60 || true"

  if ($template =~ "lxc-download") {
    $template_options = "-d ${download_template_distribution} -r ${download_template_release} -a ${download_template_architecture} --server ${download_template_server} --variant ${download_template_variant} ${template_extra_options}"
  } else {
    $template_options = ""
  }

  $lxc_create   = "/usr/bin/lxc-create -P ${my_container_dir} -n ${utsname} -t ${templates_dir}/${template} -B ${backing_store} -- ${template_options}"

  if $ensure == "present" or $ensure == "running" or $ensure == "stopped" {
    if $unprivileged {
      $subuid_offset = $facts["subuid_${unprivileged_user}_offset"]
      $subuid_size = $facts["subuid_${unprivileged_user}_size"]
      $subgid_offset = $facts["subgid_${unprivileged_user}_offset"]
      $subgid_size = $facts["subgid_${unprivileged_user}_size"]
      file { $config_file:
        ensure        => 'present',
        content       => template('lxc/unprivilegedcontainer.config.erb'),
        require       => [File[$my_container_dir], Exec["lxc-create ${utsname}"]],
      }
    } else {
      file { $config_file:
        ensure  => 'present',
        content => template('lxc/container.config.erb'),
        require => [File[$my_container_dir], Exec["lxc-create ${utsname}"]]
      }
    }
    if $unprivileged {
      exec { "lxc-create ${name}":
        command       => "${lxc_create}",
        creates       => "${my_container_dir}/${utsname}",
        logoutput     => 'on_failure',
        timeout       => 60000,
        environment   => ["HOME=${unprivileged_home}"],
        user          => $unprivileged_user,
        require       => [Package["lxc"],
                          File["${unprivileged_home}/.config/lxc/lxc.conf"],
                          User[$unprivileged_user],
                          Group[$unprivileged_group],],
      }
      file {"${my_container_dir}/${utsname}/.puppet":
        owner => $unprivileged_user,
        ensure  => directory,
        require => Exec["lxc-create ${name}"]
      }
    } else {
      exec { "lxc-create ${name}":
        command   => "${lxc_create}",
        creates   => "${my_container_dir}/${utsname}",
        logoutput => 'on_failure',
        timeout   => 60000,
        require   => Package["lxc"],
      }
      file {"${my_container_dir}/${utsname}/.puppet":
        owner => "root",
        ensure  => directory,
        require => Exec["lxc-create ${name}"]
      }
    }


    if ($puppet) and ($more_facts != undef) {
      file {
        "${container_dir}/${utsname}/rootfs/etc/facter":
          ensure  => 'directory';
        "${container_dir}/${utsname}/rootfs/etc/facter/facts.d":
          ensure  => 'directory';
        "${container_dir}/${utsname}/rootfs/etc/facter/facts.d/lxc_module.yaml":
          ensure  => 'present',
          require => Exec["lxc-create ${utsname}"],
          content => inline_template('<%= more_facts.to_yaml %>'),
      }
    }
  }
  case $ensure {
    'present', 'running': {
      if $ensure == "running" or $start_on_creation {
        if $unprivileged {
          exec { "lxc-start ${name}":
            command       => $lxc_start,
            unless        => "${lxc_info} | grep \"State.*RUNNING\"",
            logoutput     => 'on_failure',
            environment   => ["HOME=${unprivileged_home}"],
            user          => $unprivileged_user,
            require       => [Exec["lxc-create ${utsname}"],
                              File[$config_file],
                              User[$unprivileged_user],
                              Group[$unprivileged_group],],
          }
        } else {
          exec { "lxc-start ${name}":
            command   => $lxc_start,
            unless    => "${lxc_info} | grep \"State.*RUNNING\"",
            logoutput => 'on_failure',
            require   => [Exec["lxc-create ${utsname}"],
                          File[$config_file],],
          }
        }
      }
    }
    'stopped': {
      if $unprivileged {
        exec { "lxc-stop ${name}":
          command => $lxc_shutdown,
          unless  => "${lxc_info} | /bin/grep \"State.*STOPPED\"",
          environment   => ["HOME=${unprivileged_home}"],
          user          => $unprivileged_user,
          require       => [Exec["lxc-create ${utsname}"],
                            File[$config_file],
                            User[$unprivileged_user],
                            Group[$unprivileged_group],],
        }
      } else {
        exec { "lxc-stop ${name}":
          command => $lxc_shutdown,
          unless  => "${lxc_info} | /bin/grep \"State.*STOPPED\"",
          require       => [Exec["lxc-create ${utsname}"],
                            File[$config_file],],
        }
      }
    }
    'absent': {
      if $unprivileged {
        exec { "lxc-stop ${name}":
          command => $lxc_destroystop,
          onlyif  => "${lxc_info} | /bin/grep \"State.*RUNNING\"",
          environment   => ["HOME=${unprivileged_home}"],
          user          => $unprivileged_user,
          require       => [User[$unprivileged_user],
                            Group[$unprivileged_group],],
        }
      } else {
        exec { "lxc-stop ${name}":
          command => $lxc_destroystop,
          onlyif  => "${lxc_info} | /bin/grep \"State.*RUNNING\"",
        }
      }
      if $unprivileged {
        exec { "lxc-destroy ${name}":
          command => $lxc_destroy,
          onlyif  => "/usr/bin/test -d ${my_container_dir}/${name}",
          notify => Exec["remove directory for ${name}"],
          environment   => ["HOME=${unprivileged_home}"],
          user          => $unprivileged_user,
          require       => [User[$unprivileged_user],
                            Group[$unprivileged_group],
                            Exec["lxc-stop ${name}"],],
        }
      } else {
        exec { "lxc-destroy ${name}":
          command => $lxc_destroy,
          onlyif  => "/usr/bin/test -d ${my_container_dir}/${name}",
          notify => Exec["remove directory for ${name}"],
          require => Exec["lxc-stop ${name}"],
        }
      }
      exec { "remove directory for ${name}":
        # let's be very very specific so we don't delete something important
        # in case of misconfiguration
        refreshonly => true,
        command => "/bin/rm -f ${my_container_dir}/${utsname}/${utsname}.log ${my_container_dir}/${utsname}/.puppet/*; /bin/rmdir ${my_container_dir}/${utsname}/.puppet ${my_container_dir}/${utsname} || true",
        require => Exec["lxc-destroy ${name}"],
      }
    }

    default: {
      fail('ensure must be present, absent or stopped')
    }
  }

}

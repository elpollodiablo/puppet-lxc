class lxc::install::debian (
  $container_dir  = $lxc::defaults::container_dir,
  $manage_service = $lxc::defaults::manage_service,
  $manage_ipfw    = $lxc::defaults::manage_ipfw,
  $manage_ipt     = $lxc::defaults::manage_ipt,
  $manage_br      = $lxc::defaults::manage_br,
  $dns            = $lxc::defaults::dns,
  $bridge_iface   = $lxc::defaults::bridge_iface,
  $bridge_ip      = $lxc::defaults::bridge_ip,
  $bridge_gw      = $lxc::defaults::bridge_gw,
  $use_backports  = $lxc::defaults::use_backports,
  $packages       = ['lxc', 'bridge-utils', 'lxcfs', 'libpam-cgfs', 'cgmanager']
){
  include apt
  #include lxc::install

  # install backports if the user didn't decide to provide
  # working lxc 2.0 packages another way
  if $use_backports {
    include apt::backports
    apt::pin { 'jessie-backports':
      packages     => $packages,
      priority     => 600,
      release      => 'jessie-backports',
    }
    package { $packages:
      ensure       => 'latest',
      require      => [Apt::Pin['jessie-backports']],
    }
  } else {
    package { $packages:
      ensure       => 'latest'
    }
  }

  if $manage_ipfw != false {
    # ip forwarding (sysctl)
    file { '/etc/sysctl.d/20-lxc_ipforward.conf':
      ensure       => 'present',
      content      => "# PUPPET ${module_name}\nnet.ipv4.ip_forward=1\n",
      notify       => Exec['ipforward-lxc']
    }
    exec { 'ipforward-lxc':
      command      => '/sbin/sysctl net.ipv4.ip_forward=1',
      refreshonly  => true
    }
  }

  # lxc service
  # FIXME
  if $manage_service != false {
    service { "lxc":
      ensure       => 'running',
      enable       => true,
      require      => Package[$packages]
    }
  }
}

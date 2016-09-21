class lxc::unprivileged::install::debian {
  if $::lxc::unprivileged::defaults::use_jessie_pam_patch {
    file {"/etc/pam.d/common-session":
      ensure => present,
      content => "# PUPPET lxc\nsession [default=1] pam_permit.so\nsession requisite pam_deny.so\nsession required pam_permit.so\nsession required pam_unix.so\nsession optional pam_cgfs.so -c freezer,memory,name=systemd,devices\n",
    }
  }
	exec {"lxc-update-sysctl-clone-userns":
		command => "/sbin/sysctl -p /etc/sysctl.d/20-lxc-clone-userns.conf",
		require => File["/etc/sysctl.d/20-lxc-clone-userns.conf"],
		refreshonly => true,
	}	
	file {"/etc/sysctl.d/20-lxc-clone-userns.conf":
		content => "#PUPPET module lxc\nkernel.unprivileged_userns_clone=1\n",
		notify => Exec["lxc-update-sysctl-clone-userns"],
	}
}

define lxc::container::additional_packages($packages, $container_dir, $user, $distro) {
  # command uses lxc-info to determine if we need to use lxc-execute or lxc-attach.
  # if the command was successful, we touch a lockfile.
  $utsname = $name
  $joined = join($packages, "_")
  $space_joined = join($packages, " ")
  $lockfile = "${container_dir}/${utsname}/.puppet/additional_packages-${joined}-installed.lock"
  if $distro == "debian" {
    $install_command = "/usr/bin/apt-get install -y ${space_joined}"
  } elsif $distro == "redhat" {
    $install_command = "/usr/bin/yum install -y ${space_joined}"
  }
  $command = "/bin/bash -c '{ /usr/bin/lxc-info -P ${container_dir} -n ${utsname} |grep RUNNING && lxc-attach -n ${utsname} -- ${install_command} || lxc-execute -n ${utsname} -- ${install_command} ; } && touch ${lockfile}'"
  if $user == "root" {
    exec {"install additional packages for ${utsname}":
      user       => $user,
      creates    => $lockfile,
      path       => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      command    => $command,
      require    => [File["${container_dir}/${utsname}/.puppet"]],
    }  
  }else {
    exec {"install additional packages for ${utsname}":
      environment   => ["HOME=${container_dir}"],
      user       => $user,
      creates    => $lockfile,
      path       => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      command    => $command,
      require    => [File["${container_dir}/${utsname}/.puppet"]],
    }
  }
}
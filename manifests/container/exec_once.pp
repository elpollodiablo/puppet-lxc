define lxc::container::exec_once(
  $utsname = undef,
  $unprivileged_user = "root",
  $command = undef,
  $container_dir = $::lxc::defaults::container_dir,
) {
  if $utsname == undef or $command == undef {
    $my_uts_and_cmd = split($name, ':')
    $my_utsname = $my_uts_and_cmd[0]
    $my_command = $my_uts_and_cmd[1]
  } else {
    $my_utsname = $utsname
    $my_command = $command
  }
  $cmd_sha = sha1($my_command)
  $lockfile = "${container_dir}/${my_utsname}/.puppet/executed_once-${cmd_sha}.lock"
  
  $exec_command = "/bin/bash -c '{ /usr/bin/lxc-info -P ${container_dir} -n ${my_utsname} |grep RUNNING && lxc-attach -n ${my_utsname} -- ${my_command} || lxc-execute -n ${my_utsname} -- ${my_command} ; } && touch ${lockfile}'"

  exec {$name:
    environment   => ["HOME=${container_dir}"],
    user       => $unprivileged_user,
    creates    => $lockfile,
    path       => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    command    => $exec_command,
    require    => [File["${container_dir}/${my_utsname}/.puppet"]],
  }  
}

define lxc::container::file (
  $path                    = undef,
  $ensure                  = undef,
  $utsname                 = undef,
  $container_dir           = $lxc::defaults::container_dir,
  $userns_file_uid         = 0,
  $userns_file_gid         = 0,
  $unprivileged_user       = undef,
  $unprivileged_group      = undef,
  $backup                  = undef,
  $checksum                = undef,
  $content                 = undef,
  $ctime                   = undef,
  $force                   = undef,
  $group                   = undef,
  $ignore                  = undef,
  $links                   = undef,
  $mode                    = undef,
  $mtime                   = undef,
  $owner                   = undef,
  $provider                = undef,
  $purge                   = undef,
  $recurse                 = undef,
  $recurselimit            = undef,
  $replace                 = undef,
  $selinux_ignore_defaults = undef,
  $selrange                = undef,
  $selrole                 = undef,
  $seltype                 = undef,
  $seluser                 = undef,
  $show_diff               = undef,
  $source                  = undef,
  $source_permissions      = undef,
  $sourceselect            = undef,
  $target                  = undef,
  $type                    = undef,
  $validate_cmd            = undef,
  $validate_replacement    = undef
) {
  # notify {"user, group, uid, gid: ${unprivileged_user}, ${unprivileged_group}, ${unprivileged_uid}, ${unprivileged_gid} - ${name}":}
  if $unprivileged_user and (!$unprivileged_group or !$container_dir) {
    fail {"this resource needs the following attributes correctly set for use with $unprivileged_user: $unprivileged_group, $container_dir":}
  }
  if $utsname == undef or $path == undef {
    $my_uts_and_path = split($name, ':')
    $my_utsname = $my_uts_and_path[0]
    $my_path = $my_uts_and_path[1]
  } else {
    $my_utsname = $utsname
    $my_path = $path
  }

  $full_path = "${container_dir}/${my_utsname}/rootfs${my_path}"
  if ($ensure == "present" or $ensure == "directory") or ($ensure == undef) and $unprivileged_user {
    $subuid_offset = $facts["subuid_${$unprivileged_user}_offset"]
    $subgid_offset = $facts["subgid_${$unprivileged_group}_offset"]
    if $subuid_offset == '' or $subgid_offset == '' {
      warn {"can not deploy container::file resources in this run":}
    } else {
      $my_owner = $subuid_offset + $userns_file_uid
      $my_group = $subgid_offset + $userns_file_gid
    }
  } else {
    $my_owner = $owner
    $my_group = $group
  }
  if ($my_owner){
    $file_options = {
      require => [Lxc::Container[$my_utsname], File[$container_dir]],
      path => $full_path,
      ensure => $ensure,
      backup => $backup,
      checksum => $checksum,
      content => $content,
      ctime => $ctime,
      force => $force,
      group => $my_group,
      ignore => $ignore,
      links => $links,
      mode => $mode,
      mtime => $mtime,
      owner => $my_owner,
      provider => $provider,
      purge => $purge,
      recurse => $recurse,
      recurselimit => $recurselimit,
      replace => $replace,
      selinux_ignore_defaults => $selinux_ignore_defaults,
      selrange => $selrange,
      selrole => $selrole,
      seltype => $seltype,
      seluser => $seluser,
      show_diff => $show_diff,
      source => $source,
      source_permissions => $source_permissions,
      sourceselect => $sourceselect,
      target => $target,
      "type" => $type,
      validate_cmd => $validate_cmd,
      validate_replacement => $validate_replacement,
    }
    create_resources(file, {$name => delete_undef_values($file_options)})
  } else {
    fail{"I could not create ${utsname}:${full_path}":}
  }
}

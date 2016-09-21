define lxc::unprivileged::user_and_group (
  $user      = $lxc::unprivileged::defaults::user,
  $group     = $lxc::unprivileged::defaults::group,
  $uid       = $lxc::unprivileged::defaults::uid,
  $gid       = $lxc::unprivileged::defaults::gid,
  $home      = $lxc::unprivileged::defaults::home,
  $shell     = $lxc::unprivileged::defaults::shell,
  $password  = $lxc::unprivileged::defaults::password,
  $ensure    = present,
) {
  group {$group:
    ensure  => $ensure,
    gid     => $gid, 
  }
  user {$user:
    ensure       => $ensure,
    gid          => $gid, 
    uid          => $uid, 
    home         => $home,
    password     => '!!',
    shell        => $shell,
    require      => Group[$group],
  }
  file {[
      "${home}",
      "${home}/.config",
      "${home}/.config/lxc"
    ]:
    ensure       => directory,
    owner        => $user,
    group        => $group,    
    require      => User[$user],
  }
  $subuid_offset = $facts["subuid_${user}_offset"]
  $subuid_size   = $facts["subuid_${user}_size"]
  $subgid_offset = $facts["subgid_${user}_offset"]
  $subgid_size   = $facts["subgid_${user}_size"]
  # while this file is irrelevant to creating the eventual config via this module,
  # it's not irrelevant for creating the rootfs
  file {"${home}/.config/lxc/default.conf":
    content => "#PUPPET module ${module_name}\nlxc.id_map = u 0 ${subuid_offset} ${subuid_size}\nlxc.id_map = g 0 ${subgid_offset} ${subgid_size}\n",
    owner        => $user,
    group        => $group,    
    require      => [User[$user], File["${home}/.config/lxc"],],
  }
  file {"${home}/.config/lxc/lxc.conf":
    content => "#PUPPET module ${module_name}\nlxc.lxcpath = ${home}\n",
    owner        => $user,
    group        => $group,    
    require      => [User[$user], File["${home}/.config/lxc"],],
  }
}

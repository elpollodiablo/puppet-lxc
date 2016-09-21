class lxc::unprivileged::usernet ($content) {
  file {"/etc/lxc/lxc-usernet":
    content => $content,
    require => [File["/etc/lxc"],],
  }
}
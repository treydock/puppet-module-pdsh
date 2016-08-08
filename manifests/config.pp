# Private class.
class pdsh::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { '/etc/dsh':
    ensure => 'directory',
    path   => $pdsh::dsh_config_dir,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/dsh/group':
    ensure  => 'directory',
    path    => $pdsh::dsh_group_dir,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    purge   => $pdsh::dsh_group_dir_purge,
    recurse => $pdsh::dsh_group_dir_purge,
  }

}

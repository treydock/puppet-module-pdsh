# @summary Manage pdsh config
# @api private
class pdsh::config {
  assert_private()

  $rcmd_type = $pdsh::rcmd_type
  $ssh_args_append = $pdsh::ssh_args_append

  if $pdsh::use_setuid {
    $_mode = '4755'
  } else {
    $_mode = '0755'
  }

  if $pdsh::rcmd_type or $pdsh::ssh_args_append {
    $_env_ensure = 'file'
  } else {
    $_env_ensure = 'absent'
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

  file { '/usr/bin/pdsh':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => $_mode,
  }

  file { '/usr/bin/pdcp':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => $_mode,
  }

  # Template uses:
  # - $rcmd_type
  # - $ssh_args_append
  file { '/etc/profile.d/pdsh.sh':
    ensure  => $_env_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('pdsh/pdsh.sh.erb'),
  }

  # Template uses:
  # - $rcmd_type
  # - $ssh_args_append
  file { '/etc/profile.d/pdsh.csh':
    ensure  => $_env_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('pdsh/pdsh.csh.erb'),
  }

}

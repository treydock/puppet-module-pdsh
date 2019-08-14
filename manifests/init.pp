# See README.md for more details.
class pdsh (
  Boolean $with_rsh               = false,
  Boolean $with_ssh               = true,
  Boolean $with_torque            = false,
  Boolean $manage_epel            = true,
  $package_ensure                 = 'present',
  $package_name                   = $pdsh::params::package_name,
  $rsh_package_name               = $pdsh::params::rsh_package_name,
  $ssh_package_name               = $pdsh::params::ssh_package_name,
  $dshgroup_package_name          = $pdsh::params::dshgroup_package_name,
  $torque_package_name            = $pdsh::params::torque_package_name,
  Array $extra_packages           = [],
  $dsh_config_dir                 = $pdsh::params::dsh_config_dir,
  $dsh_group_dir                  = $pdsh::params::dsh_group_dir,
  Boolean $dsh_group_dir_purge    = true,
  $groups                         = undef,
  Boolean $use_setuid             = false,
  $rcmd_type                      = undef,
  $ssh_args_append                = undef,
) inherits pdsh::params {

  if $with_rsh {
    $_rsh_package_ensure   = $package_ensure
  } else {
    $_rsh_package_ensure   = 'absent'
  }

  if $with_ssh {
    $_ssh_package_ensure   = $package_ensure
  } else {
    $_ssh_package_ensure   = 'absent'
  }

  if $with_torque {
    $_torque_package_ensure = $package_ensure
  } else {
    $_torque_package_ensure = 'absent'
  }

  include pdsh::install
  include pdsh::config

  anchor { 'pdsh::start': }
  ->Class['pdsh::install']
  ->Class['pdsh::config']
  ->anchor { 'pdsh::end': }

  if $groups {
    if is_array($groups) {
      ensure_resource('pdsh::group', $groups)
    } elsif is_hash($groups) {
      create_resources('pdsh::group', $groups)
    }
  }

}

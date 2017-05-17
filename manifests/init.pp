# See README.md for more details.
class pdsh (
  $with_rsh               = false,
  $with_ssh               = true,
  $with_torque            = false,
  $package_ensure         = 'present',
  $package_name           = $pdsh::params::package_name,
  $rsh_package_name       = $pdsh::params::rsh_package_name,
  $ssh_package_name       = $pdsh::params::ssh_package_name,
  $dshgroup_package_name  = $pdsh::params::dshgroup_package_name,
  $torque_package_name    = $pdsh::params::torque_package_name,
  $extra_packages         = [],
  $dsh_config_dir         = $pdsh::params::dsh_config_dir,
  $dsh_group_dir          = $pdsh::params::dsh_group_dir,
  $dsh_group_dir_purge    = true,
  $groups                 = undef,
  $use_setuid             = $pdsh::params::use_setuid,
  $rcmd_type              = undef,
  $ssh_args_append        = undef,
) inherits pdsh::params {

  validate_bool($with_rsh)
  validate_bool($with_ssh)
  validate_bool($with_torque)
  validate_bool($use_setuid)
  validate_array($extra_packages)
  validate_bool($dsh_group_dir_purge)

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

  anchor { 'pdsh::start': }->
  Class['pdsh::install']->
  Class['pdsh::config']->
  anchor { 'pdsh::end': }

  if $groups {
    if is_array($groups) {
      ensure_resource('pdsh::group', $groups)
    } elsif is_hash($groups) {
      create_resources('pdsh::group', $groups)
    }
  }

}

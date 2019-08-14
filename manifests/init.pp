# @summary Manage pdsh
#
# @example
#   include ::pdsh
#
# @param with_rsh
#   Install rsh support
# @param with_ssh
#   Install ssh support
# @param with_torque
#   Install Torque support
# @param manage_epel
#   Boolean that determines if EPEL repo should be managed
# @param package_ensure 
#   Packages ensure property
# @param package_name
#   Main pdsh package name
# @param rsh_package_name
#   rsh support package name
# @param ssh_package_name
#   ssh support package name
# @param dshgroup_package_name
#   dshgroup support package name
# @param torque_package_name
#   Torque support package name
# @param extra_packages
#   Additional pdsh packages to install
# @param dsh_config_dir
#   Path to dsh config directory
# @param dsh_group_dir
#   Path to dsh group directory
# @param dsh_group_dir_purge
#   Sets if dsh group directory should be purged
# @param groups
#   Groups that should be defined using `pdsh::group`
# @param use_setuid
#   Should pdsh binaries have setuid
# @param rcmd_type
#   Sets default remote command via `PDSH_RCMD_TYPE` environment variable
# @param ssh_args_append
#   Additional SSH arguments set via `PDSH_SSH_ARGS_APPEND` environment variable
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

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
# @param support_dsh
#   Boolean to set if dsh support is available
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
  Boolean $support_dsh            = true,
  Boolean $manage_epel            = true,
  String $package_ensure          = 'present',
  String $package_name            = 'pdsh',
  Optional[String] $rsh_package_name      = undef,
  Optional[String] $ssh_package_name      = undef,
  Optional[String] $dshgroup_package_name = undef,
  Optional[String] $torque_package_name   = undef,
  Array $extra_packages           = [],
  Stdlib::Absolutepath $dsh_config_dir = '/etc/dsh',
  Stdlib::Absolutepath $dsh_group_dir  = '/etc/dsh/group',
  Boolean $dsh_group_dir_purge    = true,
  Variant[Array, Hash] $groups    = {},
  Boolean $use_setuid             = false,
  Optional[String] $rcmd_type     = undef,
  Optional[String] $ssh_args_append = undef,
) {

  $osfamily = dig($facts, 'os', 'family')
  if ! ($osfamily in ['RedHat','Debian']) {
    fail("Unsupported osfamily: ${osfamily}, module ${module_name} only supports RedHat and Debian")
  }

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

  contain pdsh::install
  contain pdsh::config

  Class['pdsh::install']
  ->Class['pdsh::config']

  case $groups {
    Array: {
      $groups.each |$group| {
        pdsh::group { $group: }
      }
    }
    default: {
      $groups.each |$name, $group| {
        pdsh::group { $name:
          * => $group,
        }
      }
    }
  }

}

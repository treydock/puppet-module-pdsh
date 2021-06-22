# @summary Manage pdsh
#
# @example
#   include ::pdsh
#
# @param with_rsh
#   Install rsh support
# @param with_ssh
#   Install ssh support
# @param with_genders
#   Install genders support
# @param with_slurm
#   Install SLURM support
# @param support_dsh
#   Boolean to set if dsh support is available
# @param manage_epel
#   Boolean that determines if EPEL repo should be managed
# @param manage_genders
#   Boolean that determines if genders class should be managed
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
# @param genders_package_name
#   Genders support package name
# @param slurm_package_name
#   SLURM support package name
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
  Boolean $with_genders           = false,
  Boolean $with_slurm             = false,
  Boolean $support_dsh            = true,
  Boolean $manage_epel            = true,
  Boolean $manage_genders         = true,
  String $package_ensure          = 'present',
  String $package_name            = 'pdsh',
  Optional[String] $rsh_package_name      = undef,
  Optional[String] $ssh_package_name      = undef,
  Optional[String] $dshgroup_package_name = undef,
  Optional[String] $genders_package_name  = undef,
  Optional[String] $slurm_package_name    = undef,
  Array $extra_packages           = [],
  Stdlib::Absolutepath $dsh_config_dir = '/etc/dsh',
  Stdlib::Absolutepath $dsh_group_dir  = '/etc/dsh/group',
  Boolean $dsh_group_dir_purge    = true,
  Variant[Array, Hash] $groups    = {},
  Boolean $use_setuid             = false,
  Optional[String] $rcmd_type     = undef,
  Optional[String] $ssh_args_append = undef,
) {

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

  if $with_genders {
    $_genders_package_ensure = $package_ensure
  } else {
    $_genders_package_ensure = 'absent'
  }

  if $with_slurm {
    $_slurm_package_ensure = $package_ensure
  } else {
    $_slurm_package_ensure = 'absent'
  }

  if $with_genders and $manage_genders {
    include genders
    Class['genders'] -> Class['pdsh::install']
  }

  if $manage_epel {
    include epel
    Yumrepo['epel'] -> Class['pdsh::install']
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

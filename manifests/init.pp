# See README.md for more details.
class pdsh (
  $with_rsh               = true,
  $package_ensure         = 'present',
  $package_name           = $pdsh::params::package_name,
  $rsh_package_name       = $pdsh::params::rsh_package_name,
  $dshgroup_package_name  = $pdsh::params::dshgroup_package_name,
  $extra_packages         = [],
  $dsh_config_dir         = $pdsh::params::dsh_config_dir,
  $dsh_group_dir          = $pdsh::params::dsh_group_dir,
  $groups                 = undef,
) inherits pdsh::params {

  validate_bool($with_rsh)
  validate_array($extra_packages)

  if $with_rsh {
    $_rsh_package_ensure   = $package_ensure
  } else {
    $_rsh_package_ensure   = 'absent'
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

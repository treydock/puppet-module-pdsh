# Private class.
class pdsh::params {

  case $::osfamily {
    'RedHat': {
      $package_name           = 'pdsh'
      $rsh_package_name       = 'pdsh-rcmd-rsh'
      $ssh_package_name       = 'pdsh-rcmd-ssh'
      $dshgroup_package_name  = 'pdsh-mod-dshgroup'
      $torque_package_name    = 'pdsh-mod-torque'
      $dsh_config_dir         = '/etc/dsh'
      $dsh_group_dir          = '/etc/dsh/group'

      if versioncmp($::operatingsystemrelease, '7.0') >= 0 {
        $exec_package_name = undef
      } else {
        $exec_package_name = 'pdsh-rcmd-exec'
      }
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}

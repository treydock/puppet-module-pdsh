# Private class.
class pdsh::params {

  case $::osfamily {
    'RedHat': {
      $package_name           = 'pdsh'
      $rsh_package_name       = 'pdsh-rcmd-rsh'
      $ssh_package_name       = 'pdsh-rcmd-ssh'
      $dshgroup_package_name  = 'pdsh-mod-dshgroup'
      $dsh_config_dir         = '/etc/dsh'
      $dsh_group_dir          = '/etc/dsh/group'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}

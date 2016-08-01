# Private class.
class pdsh::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  case $::osfamily {
    'RedHat': {
      include ::epel

      $_package_require  = Yumrepo['epel']
      $_package_defaults = {
        'ensure'  => $pdsh::package_ensure,
        'require' => $_package_require,
      }
    }
    default: {
      $_package_defaults = {
        'ensure'  => $pdsh::package_ensure,
      }
    }
  }

  package { 'pdsh':
    ensure  => $pdsh::package_ensure,
    name    => $pdsh::package_name,
    require => $_package_require,
  }

  package { 'pdsh-rcmd-rsh':
    ensure  => $pdsh::_rsh_package_ensure,
    name    => $pdsh::rsh_package_name,
    require => $_package_require,
  }

  package { 'pdsh-mod-dshgroup':
    ensure  => $pdsh::package_ensure,
    name    => $pdsh::dshgroup_package_name,
    require => $_package_require,
  }

  package { 'pdsh-rcmd-ssh':
    ensure  => $pdsh::_ssh_package_ensure,
    name    => $pdsh::ssh_package_name,
    require => $_package_require,
  }

  ensure_packages($pdsh::extra_packages, $_package_defaults)

}

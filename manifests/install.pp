# @summary Install pdsh
# @api private
class pdsh::install {
  assert_private()

  case $::osfamily {
    'RedHat': {
      if $pdsh::manage_epel {
        include ::epel
        $_package_require = Yumrepo['epel']
      } else {
        $_package_require = undef
      }

      $_package_defaults = {
        'ensure'  => $pdsh::package_ensure,
        'require' => $_package_require,
      }
    }
    default: {
      $_package_defaults = {
        'ensure'  => $pdsh::package_ensure,
      }
      $_package_require = undef
    }
  }

  package { 'pdsh':
    ensure  => $pdsh::package_ensure,
    name    => $pdsh::package_name,
    require => $_package_require,
  }

  if $pdsh::rsh_package_name {
    package { 'pdsh-rcmd-rsh':
      ensure  => $pdsh::_rsh_package_ensure,
      name    => $pdsh::rsh_package_name,
      require => $_package_require,
    }
  }

  if $pdsh::dshgroup_package_name {
    package { 'pdsh-mod-dshgroup':
      ensure  => $pdsh::package_ensure,
      name    => $pdsh::dshgroup_package_name,
      require => $_package_require,
    }
  }

  if $pdsh::ssh_package_name {
    package { 'pdsh-rcmd-ssh':
      ensure  => $pdsh::_ssh_package_ensure,
      name    => $pdsh::ssh_package_name,
      require => $_package_require,
    }
  }

  if $pdsh::torque_package_name {
    package { 'pdsh-mod-torque':
      ensure  => $pdsh::_torque_package_ensure,
      name    => $pdsh::torque_package_name,
      require => $_package_require,
    }
  }

  if $pdsh::genders_package_name {
    package { 'pdsh-mod-genders':
      ensure  => $pdsh::_genders_package_ensure,
      name    => $pdsh::genders_package_name,
      require => $_package_require,
    }
  }

  $pdsh::extra_packages.each |$package| {
    package { $package:
      * => $_package_defaults
    }
  }
}

# @summary Install pdsh
# @api private
class pdsh::install {
  assert_private()

  package { 'pdsh':
    ensure => $pdsh::package_ensure,
    name   => $pdsh::package_name,
  }

  if $pdsh::ssh_package_name {
    package { 'pdsh-rcmd-ssh':
      ensure => $pdsh::_ssh_package_ensure,
      name   => $pdsh::ssh_package_name,
      before => Package['pdsh'],
    }
  }

  if $pdsh::rsh_package_name {
    package { 'pdsh-rcmd-rsh':
      ensure => $pdsh::_rsh_package_ensure,
      name   => $pdsh::rsh_package_name,
      before => Package['pdsh'],
    }
  }

  if $pdsh::dshgroup_package_name {
    package { 'pdsh-mod-dshgroup':
      ensure  => $pdsh::package_ensure,
      name    => $pdsh::dshgroup_package_name,
      require => Package['pdsh'],
    }
  }

  if $pdsh::genders_package_name {
    package { 'pdsh-mod-genders':
      ensure  => $pdsh::_genders_package_ensure,
      name    => $pdsh::genders_package_name,
      require => Package['pdsh'],
    }
  }

  if $pdsh::slurm_package_name {
    package { 'pdsh-mod-slurm':
      ensure  => $pdsh::_slurm_package_ensure,
      name    => $pdsh::slurm_package_name,
      require => Package['pdsh'],
    }
  }

  $pdsh::extra_packages.each |$package| {
    package { $package:
      ensure => $pdsh::package_ensure,
    }
  }
}

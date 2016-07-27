# Private class.
class pdsh::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { 'pdsh':
    ensure => $pdsh::package_ensure,
    name   => $pdsh::package_name,
  }

  package { 'pdsh-rcmd-rsh':
    ensure => $pdsh::_rsh_package_ensure,
    name   => $pdsh::rsh_package_name,
  }

  package { 'pdsh-mod-dshgroup':
    ensure => $pdsh::package_ensure,
    name   => $pdsh::dshgroup_package_name,
  }

  ensure_packages($pdsh::extra_packages, { 'ensure' => $pdsh::package_ensure })

}

# @summary Define pdsh groups
#
# @example
#   pdsh::group { 'nodes':
#     members => 'c[01-04]',
#     aliases => 'compute',
#   }
#
# @param aliases
#   Group aliases
# @param members
#   Group members
define pdsh::group (
  Variant[Array, String] $aliases = [],
  Variant[Array, String] $members = [],
) {

  if $aliases =~ String {
    $_aliases = [$aliases]
  } else {
    $_aliases = $aliases
  }
  if $members =~ String {
    $_members = [$members]
  } else {
    $_members = $members
  }

  include pdsh

  concat { "${pdsh::dsh_group_dir}/${name}":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File[$pdsh::dsh_group_dir],
  }

  concat::fragment { "pdsh-group-${name}-header":
    target  => "${pdsh::dsh_group_dir}/${name}",
    content => "# Managed by Puppet\n\n",
    order   => '01',
  }

  $_aliases.each |$alias| {
    file { "${pdsh::dsh_group_dir}/${alias}":
      ensure => 'link',
      target => $name,
    }
  }

  $_members.each |$member| {
    concat::fragment { "pdsh-${name}-member-${member}":
      target  => "${pdsh::dsh_group_dir}/${name}",
      content => "${member}\n",
      order   => '10',
    }
  }

}

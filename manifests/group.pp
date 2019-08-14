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
  $aliases = [],
  $members = [],
) {

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

  ensure_resource('pdsh::group::alias', $aliases, {'group' => $name})
  if is_array($members) {
    each($members) |$member| {
      ensure_resource('pdsh::group::member', "${name}-${member}", {'group' => $name, 'member' => $member})
    }
  } elsif is_string($members) {
    ensure_resource('pdsh::group::member', "${name}-${members}", {'group' => $name, 'member' => $members})
  } else {
    fail('pdsh::group: unsupported type for members')
  }

}

#
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

  ensure_resources('pdsh::group::alias', $aliases, {'group' => $name})
  ensure_resources('pdsh::group::members', $members, {'group' => $name})

}

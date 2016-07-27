#
define pdsh::group::member ($group, $order = '10') {

  include pdsh

  concat::fragment { "pdsh-group-member-${name}":
    target  => "${pdsh::dsh_group_dir}/${group}",
    content => "${name}\n",
    order   => $order,
  }

}

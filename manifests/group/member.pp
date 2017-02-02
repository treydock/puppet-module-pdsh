#
define pdsh::group::member ($group, $member = $name, $order = '10') {

  include pdsh

  concat::fragment { "pdsh-${group}-member-${name}":
    target  => "${pdsh::dsh_group_dir}/${group}",
    content => "${member}\n",
    order   => $order,
  }

}

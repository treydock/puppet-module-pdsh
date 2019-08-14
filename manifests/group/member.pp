# @summary Manage a pdsh group member
#
# @param group
#   The group to add the member
# @param member
#   The member to add
# @param order
#   The order in group file to add member
define pdsh::group::member ($group, $member = $name, $order = '10') {

  include pdsh

  concat::fragment { "pdsh-${group}-member-${name}":
    target  => "${pdsh::dsh_group_dir}/${group}",
    content => "${member}\n",
    order   => $order,
  }

}

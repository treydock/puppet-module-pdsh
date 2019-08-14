# @summary Manage pdsh group alias
#
# @param group
#   The pdsh group to assign to this alias
define pdsh::group::alias ($group) {

  include pdsh

  file { "${pdsh::dsh_group_dir}/${name}":
    ensure => 'link',
    target => $group,
  }

}

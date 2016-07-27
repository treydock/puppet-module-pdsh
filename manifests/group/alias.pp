#
define pdsh::group::alias ($group) {

  include pdsh

  file { "${pdsh::dsh_group_dir}/${name}":
    ensure  => 'link',
    target  => $group,
  }

}

shared_context "pdsh::config" do
  it do
    is_expected.to contain_file('/etc/dsh').with({
      :ensure  => 'directory',
      :path    => '/etc/dsh',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0755',
    })
  end

  it do
    is_expected.to contain_file('/etc/dsh/group').with({
      :ensure  => 'directory',
      :path    => '/etc/dsh/group',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0755',
    })
  end
end

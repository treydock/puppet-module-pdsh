shared_context "pdsh::install" do
  it do
    is_expected.to contain_package('pdsh').only_with({
      :ensure   => 'present',
      :name     => 'pdsh',
      :require  => 'Yumrepo[epel]'
    })
  end
end

shared_examples 'pdsh::install' do |_facts|
  it do
    is_expected.to contain_package('pdsh').only_with(
      ensure: 'present',
      name: 'pdsh',
    )
  end
end

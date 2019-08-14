shared_examples 'pdsh::install' do |facts|
  package_require = if facts[:os]['family'] == 'RedHat'
                      'Yumrepo[epel]'
                    else
                      nil
                    end

  it do
    is_expected.to contain_package('pdsh').only_with(ensure: 'present',
                                                     name: 'pdsh',
                                                     require: package_require)
  end
end

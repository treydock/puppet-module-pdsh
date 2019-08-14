require 'spec_helper'

describe 'pdsh' do
  on_supported_os(supported_os: [
                    {
                      'operatingsystem' => 'RedHat',
                      'operatingsystemrelease' => ['6', '7'],
                    },
                  ]).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(concat_basedir: '/dne')
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('pdsh') }
      it { is_expected.to contain_class('pdsh::params') }

      it { is_expected.to contain_anchor('pdsh::start').that_comes_before('Class[pdsh::install]') }
      it { is_expected.to contain_class('pdsh::install').that_comes_before('Class[pdsh::config]') }
      it { is_expected.to contain_class('pdsh::config').that_comes_before('Anchor[pdsh::end]') }
      it { is_expected.to contain_anchor('pdsh::end') }

      include_context 'pdsh::install'
      include_context 'pdsh::config'

      # Test validate_bool parameters
      [
      ].each do |param|
        context "with #{param} => 'foo'" do
          let(:params) { { param.to_sym => 'foo' } }

          it 'raises an error' do
            expect { is_expected.to compile }.to raise_error(%r{is not a boolean})
          end
        end
      end
    end # end context
  end # end on_supported_os loop
end # end describe

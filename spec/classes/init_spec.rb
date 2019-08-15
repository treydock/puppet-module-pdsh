require 'spec_helper'

describe 'pdsh' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(concat_basedir: '/dne')
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('pdsh') }

      it { is_expected.to contain_class('pdsh::install').that_comes_before('Class[pdsh::config]') }
      it { is_expected.to contain_class('pdsh::config') }

      include_context 'pdsh::install', facts
      include_context 'pdsh::config', facts

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

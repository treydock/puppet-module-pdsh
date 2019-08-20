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

      it { is_expected.not_to contain_class('genders') }

      context 'with genders support' do
        let(:params) { { with_genders: true, manage_genders: true } }

        it { is_expected.to contain_class('genders').that_comes_before('Class[pdsh::install]') }
      end
    end # end context
  end # end on_supported_os loop
end # end describe

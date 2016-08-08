require 'spec_helper_acceptance'

describe 'pdsh class:' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'pdsh': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('pdsh') do
      it { should be_installed }
    end

    describe file('/etc/dsh') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/dsh/group') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end
  end
end

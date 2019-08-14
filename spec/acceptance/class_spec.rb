require 'spec_helper_acceptance'

describe 'pdsh class:' do
  context 'default parameters' do
    it 'runs successfully' do
      pp = <<-EOS
      class { 'pdsh': }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('pdsh') do
      it { is_expected.to be_installed }
    end

    if fact('os.family') == 'RedHat'
      describe file('/etc/dsh') do
        it { is_expected.to be_directory }
        it { is_expected.to be_mode 755 }
        it { is_expected.to be_owned_by 'root' }
        it { is_expected.to be_grouped_into 'root' }
      end

      describe file('/etc/dsh/group') do
        it { is_expected.to be_directory }
        it { is_expected.to be_mode 755 }
        it { is_expected.to be_owned_by 'root' }
        it { is_expected.to be_grouped_into 'root' }
      end
    end
  end
end

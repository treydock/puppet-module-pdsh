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

  context 'define group', if: fact('os.family') == 'RedHat' do
    it 'runs successfully' do
      pp = <<-EOS
      class { 'pdsh': }
      pdsh::group { 'compute':
        members => 'c[01-04]',
        aliases => 'all',
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/etc/dsh/group/compute') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 644 }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      its(:content) { is_expected.to match %r{^c\[01-04\]$} }
    end

    describe file('/etc/dsh/group/all') do
      it { is_expected.to be_symlink }
      it { is_expected.to be_linked_to 'compute' }
    end
  end
end

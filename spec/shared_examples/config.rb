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

  it do
    is_expected.to contain_file('/usr/bin/pdsh').with({
      :ensure => 'present',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755',
    })
  end

  it do
    is_expected.to contain_file('/usr/bin/pdcp').with({
      :ensure => 'present',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755',
    })
  end

  it do
    is_expected.to contain_file('/etc/profile.d/pdsh.sh').with({
      :ensure => 'absent',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0644',
    })
  end

  it do
    is_expected.to contain_file('/etc/profile.d/pdsh.csh').with({
      :ensure => 'absent',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0644',
    })
  end

  context 'when use_setuid is true' do
    let(:params) {{ :use_setuid => true }}

    it { is_expected.to contain_file('/usr/bin/pdsh').with_mode('4755') }
    it { is_expected.to contain_file('/usr/bin/pdcp').with_mode('4755') }
  end

  context 'when rcmd_type defined' do
    let(:params) {{ :rcmd_type => 'ssh' }}

    it { is_expected.to contain_file('/etc/profile.d/pdsh.sh').with_ensure('file') }
    it { is_expected.to contain_file('/etc/profile.d/pdsh.csh').with_ensure('file') }

    it do
      verify_contents(catalogue, '/etc/profile.d/pdsh.sh', ['export PDSH_RCMD_TYPE="ssh"'])
    end

    it do
      verify_contents(catalogue, '/etc/profile.d/pdsh.csh', ['setenv PDSH_RCMD_TYPE "ssh"'])
    end
  end

  context 'when ssh_args_append defined' do
    let(:params) {{ :ssh_args_append => '-oStrictHostKeyChecking=no' }}

    it { is_expected.to contain_file('/etc/profile.d/pdsh.sh').with_ensure('file') }
    it { is_expected.to contain_file('/etc/profile.d/pdsh.csh').with_ensure('file') }

    it do
      verify_contents(catalogue, '/etc/profile.d/pdsh.sh', ['export PDSH_SSH_ARGS_APPEND="-oStrictHostKeyChecking=no"'])
    end

    it do
      verify_contents(catalogue, '/etc/profile.d/pdsh.csh', ['setenv PDSH_SSH_ARGS_APPEND "-oStrictHostKeyChecking=no"'])
    end
  end
end

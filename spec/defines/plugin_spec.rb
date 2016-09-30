require 'spec_helper'

describe 'nrpe::plugin' do
  # setting the global facts for all test if not overwritten locally
  let(:facts) do
    {
      :osfamily          => 'RedHat',
      :lsbmajdistrelease => '6',
      :architecture      => 'x86_64',
    }
  end
  context 'should create plugin file with all options specified' do
    let(:title) { 'check_root_partition' }
    let(:params) do
      { :plugin     => 'check_disk',
        :libexecdir => '/usr/lib64/nagios/plugins',
        :args       => '-w 20% -c 10% -p /',
      }
    end

    it { should compile.with_all_deps }

    it { should contain_class('nrpe') }

    it {
      should contain_file('nrpe_plugin_check_root_partition').with({
        'ensure'  => 'file',
        'path'    => '/etc/nrpe.d/check_root_partition.cfg',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => 'File[nrpe_config_dot_d]',
        'notify'  => 'Service[nrpe_service]',
      })
    }

    it {
      should contain_file('nrpe_plugin_check_root_partition') \
        .with_content(/^command\[check_root_partition\]=\/usr\/lib64\/nagios\/plugins\/check_disk -w 20% -c 10% -p \/$/)
    }
  end

  context 'with ensure set to absent' do
    let(:title) { 'check_root_partition' }
    let(:params) do
      { :ensure     => 'absent',
        :plugin     => 'check_disk',
        :libexecdir => '/usr/lib64/nagios/plugins',
        :args       => '-w 20% -c 10% -p /',
      }
    end

    it { should compile.with_all_deps }

    it { should contain_class('nrpe') }

    it {
      should contain_file('nrpe_plugin_check_root_partition').with({
        'ensure'  => 'absent',
        'path'    => '/etc/nrpe.d/check_root_partition.cfg',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => 'File[nrpe_config_dot_d]',
        'notify'  => 'Service[nrpe_service]',
      })
    }
  end

  context 'should create plugin file with no args param specified' do
    let(:title) { 'check_load' }

    it { should compile.with_all_deps }

    it { should contain_class('nrpe') }

    it {
      should contain_file('nrpe_plugin_check_load').with({
        'ensure'  => 'file',
        'path'    => '/etc/nrpe.d/check_load.cfg',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => 'File[nrpe_config_dot_d]',
        'notify'  => 'Service[nrpe_service]',
      })
    }

    it {
      should contain_file('nrpe_plugin_check_load') \
        .with_content(/^command\[check_load\]=\/usr\/lib64\/nagios\/plugins\/check_load$/)
    }

    it {
      should_not contain_file('nrpe_plugin_check_load') \
        .with_content(/^command\[check_load\]=\/usr\/lib64\/nagios\/plugins\/check_load UNSET$/)
    }
  end

  context 'with ensure set to an invalid value' do
    let(:title) { 'check_root_partition' }
    let(:params) do
      { :ensure => 'invalid',
        :plugin => 'check_disk',
        :args   => '-w 20% -c 10% -p /',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe::plugin')
      }.to raise_error(Puppet::Error,/nrpe::plugin::check_root_partition::ensure must be 'present' or 'absent'\. Detected value is <invalid>\./)
    end
  end

  context 'with libexecdir set to a non absolute path' do
    let(:title) { 'check_root_partition' }
    let(:params) do
      { :plugin     => 'check_disk',
        :libexecdir => 'invalid/path',
        :args       => '-w 20% -c 10% -p /',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe::plugin')
      }.to raise_error(Puppet::Error)
    end
  end

  context 'should create plugin file with no command_prefix param specified' do
    let(:title) { 'check_disk' }

    it { should compile.with_all_deps }

    it { should contain_class('nrpe') }

    it {
      should contain_file('nrpe_plugin_check_disk') \
        .with_content(/^command\[check_disk\]=\/usr\/lib64\/nagios\/plugins\/check_disk$/)
    }

    it {
      should_not contain_file('nrpe_plugin_check_disk') \
        .with_content(/^command\[check_disk\]=UNSET\/usr\/lib64\/nagios\/plugins\/check_disk$/)
    }
  end

  context 'should create plugin file with command_prefix set to USE_DEFAULTS' do
    let(:title) { 'check_disk' }
    let(:params) { { :command_prefix => 'USE_DEFAULTS' } }

    it {
      should contain_file('nrpe_plugin_check_disk') \
        .with_content(/^command\[check_disk\]=\/usr\/bin\/sudo \/usr\/lib64\/nagios\/plugins\/check_disk$/)
    }
  end

  context 'should create plugin file command_prefix set to /path/to/prefix' do
    let(:title) { 'check_disk' }
    let(:params) { { :command_prefix => '/path/to/prefix' } }

    it {
      should contain_file('nrpe_plugin_check_disk') \
        .with_content(/^command\[check_disk\]=\/path\/to\/prefix \/usr\/lib64\/nagios\/plugins\/check_disk$/)
    }
  end

  context 'with command_prefix set to a non absolute path' do
    let(:title) { 'check_disk' }
    let(:params) { { :command_prefix => 'invalid/path' } }

    it 'should fail' do
      expect {
        should contain_class('nrpe::plugin')
      }.to raise_error(Puppet::Error)
    end
  end
end

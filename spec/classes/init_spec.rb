require 'spec_helper'
describe 'nrpe' do

  context 'with default options on unsupported osfamily' do
    let(:facts) { { :osfamily => 'Unsupported' } }

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error,/nrpe supports osfamilies RedHat and Suse. Detected osfamily is <Unsupported>./)
    end
  end

  context 'with default options on EL 6' do
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it { should compile.with_all_deps }

    it { should contain_class('nrpe') }

    it {
      should contain_package('nrpe_package').with({
        'ensure'    => 'present',
        'name'      => 'nrpe',
        'adminfile' => nil,
        'source'    => nil,
      })
    }

    it {
      should contain_package('nagios_plugins_package').with({
        'ensure'    => 'present',
        'name'      => 'nagios-plugins',
        'adminfile' => nil,
        'source'    => nil,
        'before'    => 'Service[nrpe_service]',
      })
    }

    it {
      should contain_file('nrpe_config').with({
        'ensure'  => 'file',
        'path'    => '/etc/nagios/nrpe.cfg',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => 'Package[nrpe_package]',
      })
    }

    it { should contain_file('nrpe_config').with_content(/^log_facility=daemon$/) }
    it { should contain_file('nrpe_config').with_content(/^pid_file=\/var\/run\/nrpe\/nrpe.pid$/) }
    it { should contain_file('nrpe_config').with_content(/^server_port=5666$/) }
    it { should_not contain_file('nrpe_config').with_content(/^server_address=127.0.0.1$/) }
    it { should contain_file('nrpe_config').with_content(/^nrpe_user=nrpe$/) }
    it { should contain_file('nrpe_config').with_content(/^nrpe_group=nrpe$/) }
    it { should contain_file('nrpe_config').with_content(/^allowed_hosts=127.0.0.1$/) }
    it { should contain_file('nrpe_config').with_content(/^dont_blame_nrpe=0$/) }
    it { should contain_file('nrpe_config').with_content(/^allow_bash_command_substitution=0$/) }
    it { should_not contain_file('nrpe_config').with_content(/^command_prefix=\/usr\/bin\/sudo$/) }
    it { should contain_file('nrpe_config').with_content(/^debug=0$/) }
    it { should contain_file('nrpe_config').with_content(/^command_timeout=60$/) }
    it { should contain_file('nrpe_config').with_content(/^connection_timeout=300$/) }
    it { should contain_file('nrpe_config').with_content(/^allow_weak_random_seed=0$/) }
    it { should contain_file('nrpe_config').with_content(/^include_dir=\/etc\/nrpe.d$/) }
    it { should_not contain_file('nrpe_config').with_content(/^command\[$/) }

    it {
      should contain_file('nrpe_config_dot_d').with({
        'ensure'  => 'directory',
        'path'    => '/etc/nrpe.d',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'purge'   => 'false',
        'recurse' => 'true',
        'require' => 'Package[nrpe_package]',
        'notify'  => 'Service[nrpe_service]',
      })
    }

    it {
      should contain_service('nrpe_service').with({
        'ensure'    => 'running',
        'name'      => 'nrpe',
        'enable'    => true,
        'subscribe' => 'File[nrpe_config]',
      })
    }
  end

  context 'with default options on Suse 11' do
    let(:facts) do
      { :osfamily          => 'Suse',
        :lsbmajdistrelease => '11',
      }
    end

    it { should compile.with_all_deps }

    it { should contain_class('nrpe') }

    it {
      should contain_package('nrpe_package').with({
        'ensure'    => 'present',
        'name'      => 'nagios-nrpe',
        'adminfile' => nil,
        'source'    => nil,
      })
    }

    it {
      should contain_package('nagios_plugins_package').with({
        'ensure'    => 'present',
        'name'      => 'nagios-plugins',
        'adminfile' => nil,
        'source'    => nil,
        'before'    => 'Service[nrpe_service]',
      })
    }

    it {
      should contain_file('nrpe_config').with({
        'ensure'  => 'file',
        'path'    => '/etc/nagios/nrpe.cfg',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => 'Package[nrpe_package]',
      })
    }

    it { should contain_file('nrpe_config').with_content(/^log_facility=daemon$/) }
    it { should contain_file('nrpe_config').with_content(/^pid_file=\/var\/run\/nrpe\/nrpe.pid$/) }
    it { should contain_file('nrpe_config').with_content(/^server_port=5666$/) }
    it { should_not contain_file('nrpe_config').with_content(/^server_address=127.0.0.1$/) }
    it { should contain_file('nrpe_config').with_content(/^nrpe_user=nagios$/) }
    it { should contain_file('nrpe_config').with_content(/^nrpe_group=nagios$/) }
    it { should contain_file('nrpe_config').with_content(/^allowed_hosts=127.0.0.1$/) }
    it { should contain_file('nrpe_config').with_content(/^dont_blame_nrpe=0$/) }
    it { should contain_file('nrpe_config').with_content(/^allow_bash_command_substitution=0$/) }
    it { should_not contain_file('nrpe_config').with_content(/^command_prefix=\/usr\/bin\/sudo$/) }
    it { should contain_file('nrpe_config').with_content(/^debug=0$/) }
    it { should contain_file('nrpe_config').with_content(/^command_timeout=60$/) }
    it { should contain_file('nrpe_config').with_content(/^connection_timeout=300$/) }
    it { should contain_file('nrpe_config').with_content(/^allow_weak_random_seed=0$/) }
    it { should contain_file('nrpe_config').with_content(/^include_dir=\/etc\/nrpe.d$/) }
    it { should_not contain_file('nrpe_config').with_content(/^command\[$/) }

    it {
      should contain_service('nrpe_service').with({
        'ensure'    => 'running',
        'name'      => 'nrpe',
        'enable'    => true,
        'subscribe' => 'File[nrpe_config]',
      })
    }
  end

  context 'with nrpe_config set to a non absolute path' do
    let(:params) { { :nrpe_config => 'invalid/path' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error)
    end
  end

  context 'with nrpe_config_mode set to an invalid value' do
    let(:params) { { :nrpe_config_mode => '666' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error,/nrpe::nrpe_config_mode must be a four digit octal mode. Detected value is <666>./)
    end
  end

  context 'with libexecdir set to a non absolute path' do
    let(:params) { { :libexecdir => 'invalid/path' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error)
    end
  end

  context 'with pid_file set to a non absolute path' do
    let(:params) { { :pid_file => 'invalid/path' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error)
    end
  end

  context 'with server_port set to an invalid setting (non-digit)' do
    let(:params) { { :server_port => 'not_a_port' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error,/nrpe::server_port must be a valid port number between 0 and 65535, inclusive. Detected value is <not_a_port>./)
    end
  end

  context 'with server_port set to a valid digit, but invalid port number (above 65535)' do
    let(:params) { { :server_port => '1000000' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error,/nrpe::server_port must be a valid port number between 0 and 65535, inclusive. Detected value is <1000000>./)
    end
  end

  context 'with server_port set to a valid digit, but invalid port number (negative)' do
    let(:params) { { :server_port => '-23' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error,/nrpe::server_port must be a valid port number between 0 and 65535, inclusive. Detected value is <-23>./)
    end
  end

  context 'with server_address_enable set to true' do
    let(:params) { { :server_address_enable => true  } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it { should compile.with_all_deps }

    it { should contain_file('nrpe_config').with_content(/^server_address=127.0.0.1$/) }
  end

  context 'with server_address_enable set to to stringified \'true\'' do
    let(:params) { { :server_address_enable => 'true' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it { should compile.with_all_deps }

    it { should contain_file('nrpe_config').with_content(/^server_address=127.0.0.1$/) }
  end

  context 'with multiple entries for allowed_hosts' do
    let(:params) { { :allowed_hosts => ['127.0.0.1', 'poller.example.com'] } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it { should compile.with_all_deps }

    it { should contain_file('nrpe_config').with_content(/^allowed_hosts=127.0.0.1,poller.example.com$/) }
  end

  context 'with allowed_hosts set to an invalid type (non-array)' do
    let(:params) { { :allowed_hosts => 'not_an_array' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error)
    end
  end

  context 'with dont_blame_nrpe set to invalid value' do
    let(:params) { { :dont_blame_nrpe => '2' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error,/nrpe::dont_blame_nrpe must be 0 or 1. Detected value is <2>./)
    end
  end

  context 'with allow_bash_command_substitution set to invalid value' do
    let(:params) { { :allow_bash_command_substitution => '2' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error,/nrpe::allow_bash_command_substitution must be 0 or 1. Detected value is <2>./)
    end
  end

  context 'with command_prefix_enable set to true' do
    let(:params) { { :command_prefix_enable => true  } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it { should compile.with_all_deps }

    it { should contain_file('nrpe_config').with_content(/^command_prefix=\/usr\/bin\/sudo$/) }
  end

  context 'with command_prefix_enable set to to stringified \'true\'' do
    let(:params) { { :command_prefix_enable => 'true' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it { should compile.with_all_deps }

    it { should contain_file('nrpe_config').with_content(/^command_prefix=\/usr\/bin\/sudo$/) }
  end

  context 'with command_prefix set to a non absolute path' do
    let(:params) { { :command_prefix => 'invalid/path' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error)
    end
  end

  context 'with debug set to invalid value' do
    let(:params) { { :debug => '2' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error,/nrpe::debug must be 0 or 1. Detected value is <2>./)
    end
  end

  context 'with command_timeout set to an invalid setting' do
    let(:params) { { :command_timeout => '-1' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error,/nrpe::command_timeout must be a postive integer. Detected value is <-1>./)
    end
  end

  context 'with connection_timeout set to an invalid setting' do
    let(:params) { { :connection_timeout => '-1' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error,/nrpe::connection_timeout must be a postive integer. Detected value is <-1>./)
    end
  end

  context 'with allow_weak_random_seed set to invalid value' do
    let(:params) { { :allow_weak_random_seed => '2' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error,/nrpe::allow_weak_random_seed must be 0 or 1. Detected value is <2>./)
    end
  end

  context 'with include_dir set to invalid value' do
    let(:params) { { :include_dir => 'invalid/path' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error)
    end
  end

  context 'with service_ensure set to invalid value' do
    let(:params) { { :service_ensure => 'present' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error,/nrpe::service_ensure must be \'running\' or \'stopped\'. Detected value is <present>./)
    end
  end

  context 'with service_enable set to invalid value' do
    let(:params) { { :service_enable => 'invalid' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error)
    end
  end

  context 'with plugins specified as a hash on 32 bit EL 6' do
    let(:params) {
      {
        :plugins => {
          'check_root_partition' => {
            'plugin'     => 'check_disk',
            'libexecdir' => '/usr/lib/nagios/plugins',
            'args'       => '-w 20% -c 10% -p /',
          },
          'check_load' => {
            'args' => '-w 10,8,8 -c 12,10,9',
          },
          'check_me_out' => {
            'ensure' => 'absent',
          },
        }
      }
    }
    let(:facts) do
      { :architecture      => 'i386',
        :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
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
        .with_content(/^command\[check_root_partition\]=\/usr\/lib\/nagios\/plugins\/check_disk -w 20% -c 10% -p \/$/)
    }

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
        .with_content(/^command\[check_load\]=\/usr\/lib\/nagios\/plugins\/check_load -w 10,8,8 -c 12,10,9$/)
    }

    it {
      should contain_file('nrpe_plugin_check_me_out').with({
        'ensure'  => 'absent',
        'path'    => '/etc/nrpe.d/check_me_out.cfg',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => 'File[nrpe_config_dot_d]',
        'notify'  => 'Service[nrpe_service]',
      })
    }
  end

  context 'with plugins specified as a hash on 64 bit EL 6' do
    let(:params) {
      {
        :plugins => {
          'check_root_partition' => {
            'plugin'     => 'check_disk',
            'libexecdir' => '/usr/lib64/nagios/plugins',
            'args'       => '-w 20% -c 10% -p /',
          },
          'check_load' => {
            'args' => '-w 10,8,8 -c 12,10,9',
          },
          'check_me_out' => {
            'ensure' => 'absent',
          },
        }
      }
    }
    let(:facts) do
      { :architecture      => 'x86_64',
        :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
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
        .with_content(/^command\[check_load\]=\/usr\/lib64\/nagios\/plugins\/check_load -w 10,8,8 -c 12,10,9$/)
    }

    it {
      should contain_file('nrpe_plugin_check_me_out').with({
        'ensure'  => 'absent',
        'path'    => '/etc/nrpe.d/check_me_out.cfg',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => 'File[nrpe_config_dot_d]',
        'notify'  => 'Service[nrpe_service]',
      })
    }
  end

  context 'with plugins specified as a hash on Suse 11' do
    let(:params) {
      {
        :plugins => {
          'check_root_partition' => {
            'plugin'     => 'check_disk',
            'libexecdir' => '/usr/lib/nagios/plugins',
            'args'       => '-w 20% -c 10% -p /',
          },
          'check_load' => {
            'args' => '-w 10,8,8 -c 12,10,9',
          },
          'check_me_out' => {
            'ensure' => 'absent',
          },
        }
      }
    }
    let(:facts) do
      { :osfamily          => 'Suse',
        :lsbmajdistrelease => '11',
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
        .with_content(/^command\[check_root_partition\]=\/usr\/lib\/nagios\/plugins\/check_disk -w 20% -c 10% -p \/$/)
    }

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
        .with_content(/^command\[check_load\]=\/usr\/lib\/nagios\/plugins\/check_load -w 10,8,8 -c 12,10,9$/)
    }

    it {
      should contain_file('nrpe_plugin_check_me_out').with({
        'ensure'  => 'absent',
        'path'    => '/etc/nrpe.d/check_me_out.cfg',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => 'File[nrpe_config_dot_d]',
        'notify'  => 'Service[nrpe_service]',
      })
    }
  end

  context 'with plugins specified as an invalid type (array)' do
    let(:params) { { :plugins => ['an','array'] } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error)
    end
  end

  context 'with purge_plugins specified as not close to a boolean' do
    let(:params) { { :purge_plugins => 'not even close to a boolean' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it do
      expect {
        should contain_class('nrpe')
      }.to raise_error(Puppet::Error)
    end
  end


  ['true',true,'false',false].each do |value|
    context "with purge_plugins specified as #{value}" do
      let(:params) { { :purge_plugins => value } }
      let(:facts) do
        { :osfamily          => 'RedHat',
          :lsbmajdistrelease => '6',
        }
      end

      it {
        should contain_file('nrpe_config_dot_d').with({
          'ensure'  => 'directory',
          'path'    => '/etc/nrpe.d',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'purge'   => value,
          'recurse' => 'true',
          'require' => 'Package[nrpe_package]',
          'notify'  => 'Service[nrpe_service]',
        })
      }
    end
  end
end

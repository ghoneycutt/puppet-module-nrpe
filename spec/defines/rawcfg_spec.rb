require 'spec_helper'

describe 'nrpe::rawcfg' do
  # setting the global facts for all test if not overwritten locally
  let(:facts) do
    {
      :osfamily          => 'RedHat',
      :lsbmajdistrelease => '6',
      :architecture      => 'x86_64',
    }
  end
  context 'should create raw file with content specified' do
    let(:title) { 'raw_baseline' }
    let(:params) do
      { :content     => 'rawcontent', }
    end

    it { should compile.with_all_deps }

    it { should contain_class('nrpe') }

    it {
      should contain_file('nrpe_rawcfg_raw_baseline').with({
        'ensure'  => 'file',
        'path'    => '/etc/nrpe.d/raw_baseline.cfg',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => 'File[nrpe_config_dot_d]',
        'notify'  => 'Service[nrpe_service]',
      })
    }

    it {
      should contain_file('nrpe_rawcfg_raw_baseline') \
        .with_content(/^rawcontent$/)
    }
  end

  context 'with ensure set to absent' do
    let(:title) { 'raw_baseline' }
    let(:params) do
      { :ensure     => 'absent', }
    end

    it { should compile.with_all_deps }

    it { should contain_class('nrpe') }

    it {
      should contain_file('nrpe_rawcfg_raw_baseline').with({
        'ensure'  => 'absent',
        'path'    => '/etc/nrpe.d/raw_baseline.cfg',
        'require' => 'File[nrpe_config_dot_d]',
        'notify'  => 'Service[nrpe_service]',
      })
    }
  end

  context 'should create empty file with no content specified' do
    let(:title) { 'raw_baseline' }

    it { should compile.with_all_deps }

    it { should contain_class('nrpe') }

    it {
      should contain_file('nrpe_rawcfg_raw_baseline').with({
        'ensure'  => 'file',
        'path'    => '/etc/nrpe.d/raw_baseline.cfg',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => 'File[nrpe_config_dot_d]',
        'notify'  => 'Service[nrpe_service]',
      })
    }

    it {
      should_not contain_file('nrpe_rawcfg_raw_baseline') \
        .with_content(/UNSET/)
    }
  end

  context 'with ensure set to an invalid value' do
    let(:title) { 'raw_baseline' }
    let(:params) do
      { :ensure => 'invalid',
        :content => 'rawcontent',
      }
    end

    it 'should fail' do
      expect {
        should contain_class('nrpe::rawcfg')
      }.to raise_error(Puppet::Error,/nrpe::rawcfg::raw_baseline::ensure must be 'present' or 'absent'\. Detected value is <invalid>\./)
    end
  end
end

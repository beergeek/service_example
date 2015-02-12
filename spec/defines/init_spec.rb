require 'spec_helper'
describe 'service_example' do
  let(:facts) {
    {
      :osfamily                   => 'windows',
      :operatingsystem            => 'windows',
      :operatingsystemmajrelease  => '6',
      :operatingsystemrelease     => '6.3.9600',
    }
  }
  let(:title) { 'run_windows_stuff' }

  context 'runs with defaults, plus the script parameters' do
    let(:params) {
      {
        :display_name => 'run_windows_stuff',
        :command      => 'C:\Windows\regedit.exe',
      }
    }
  
    it {
      should contain_registry__service('run_windows_stuff_service').with(
        'ensure'        => 'present',
        'display_name'  => 'run_windows_stuff',
        'command'       => 'C:\Windows\regedit.exe',
        'start'					=> 'automatic',
      )
    }
  end
  
  context 'fails with incorrect parameter for start' do
    let(:params) {
      {
        :display_name => 'run_windows_stuff',
        :command      => 'C:\Windows\regedit.exe',
        :start				=> 'sleep',
      }
    }
    
    it {
    	expect { should compile }.to raise_error
    }
  end
  
  context 'fails with incorrect parameter for ensure' do
    let(:params) {
      {
        :display_name => 'run_windows_stuff',
        :command      => 'C:\Windows\regedit.exe',
        :ensure				=> 'sleep',
      }
    }
    
    it {
    	expect { should compile }.to raise_error
    }
  end
  
  context 'with user managed' do
    let(:params) {
      {
        :display_name => 'run_windows_stuff',
        :command      => 'C:\Windows\regedit.exe',
        :manage_user	=> true,
        :user_name		=> 'testUser',
      }
    }
  
  	it {
  		should contain_user('run_windows_stuff_user').with(
  			'ensure'				=> 'present',
  			'name'					=> 'testUser',
  		).that_comes_before('Registry::Service[run_windows_stuff_service]')
  	}
  
    it {
      should contain_registry__service('run_windows_stuff_service').with(
        'ensure'        => 'present',
        'display_name'  => 'run_windows_stuff',
        'command'       => 'C:\Windows\regedit.exe',
        'start'					=> 'automatic',
      )
    }
  end
end

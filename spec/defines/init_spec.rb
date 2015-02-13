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
      should contain_registry__service('run_windows_stuff').with(
        'ensure'        => 'present',
        'display_name'  => 'run_windows_stuff',
        'command'       => 'C:\Windows\regedit.exe',
        'start'					=> 'automatic',
      ).that_notifies('Reboot[run_windows_stuff_after]')
    }
    
    it {
    	should contain_reboot('after').with(
    		'apply'		=> 'finished',
    		'timeout'	=> '10',
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
        :password			=> '12sdER45^&',
        :user_name		=> 'testUser',
      }
    }
  
  	it {
  		should contain_user('run_windows_stuff_user').with(
  			'ensure'				=> 'present',
  			'name'					=> 'testUser',
  			'password'			=> '12sdER45^&',
  		).that_comes_before('Registry::Service[run_windows_stuff]')
  	}
  	
  	it {
  		should contain_registry_value('run_windows_stuff_reg').with(
  		  'ensure'	=> 'present',
  			'path'		=> "HKLM\\System\\CurrentControlSet\\Services\\run_windows_stuff\\ObjectName",
  			'data'		=> 'testUser',
  			'type'		=> 'string',
  		).that_requires('Registry::Service[run_windows_stuff]')
  		.that_notifies('Reboot[run_windows_stuff_after]')
  	}
  
    it {
      should contain_registry__service('run_windows_stuff').with(
        'ensure'        => 'present',
        'display_name'  => 'run_windows_stuff',
        'command'       => 'C:\Windows\regedit.exe',
        'start'					=> 'automatic',
      ).that_notifies('Reboot[run_windows_stuff_after]')
    }
    
    it {
    	should contain_reboot('after').with(
    		'apply'		=> 'finished',
    		'timeout'	=> '10',
    	)
    }
  end
end

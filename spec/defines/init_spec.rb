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
      should contain_registry_key('run_windows_stuff').with(
        'ensure'  => 'present',
        'path'    => 'HKLM\System\CurrentControlSet\Services\run_windows_stuff',
      )
    }

    it {
      should contain_registry_value('run_windows_stuff_reg_displayname').with(
        'ensure'  => 'present',
        'path'    => 'HKLM\System\CurrentControlSet\Services\run_windows_stuff\DisplayName',
        'data'		=> 'run_windows_stuff',
        'type'		=> 'string',
      ).that_requires('Registry_key[run_windows_stuff]')
      .that_notifies('Reboot[run_windows_stuff_after]')
    }

    it {
      should contain_registry_value('run_windows_stuff_reg_start').with(
        'ensure'  => 'present',
        'path'    => 'HKLM\System\CurrentControlSet\Services\run_windows_stuff\Start',
        'data'		=> '2',
        'type'		=> 'dword',
      ).that_requires('Registry_key[run_windows_stuff]')
      .that_notifies('Reboot[run_windows_stuff_after]')
    }

    it {
      should contain_registry_value('run_windows_stuff_reg_command').with(
        'ensure'  => 'present',
        'path'    => 'HKLM\System\CurrentControlSet\Services\run_windows_stuff\ImagePath',
        'data'		=> 'C:\Windows\regedit.exe',
        'type'		=> 'string',
      ).that_requires('Registry_key[run_windows_stuff]')
      .that_notifies('Reboot[run_windows_stuff_after]')
    }

    it {
      should contain_registry_value('run_windows_stuff_reg_type').with(
        'ensure'  => 'present',
        'path'    => 'HKLM\System\CurrentControlSet\Services\run_windows_stuff\Type',
        'data'		=> 0x00000010,
        'type'		=> 'dword',
      ).that_requires('Registry_key[run_windows_stuff]')
      .that_notifies('Reboot[run_windows_stuff_after]')
    }

    it {
      should contain_registry_value('run_windows_stuff_reg_error').with(
        'ensure'  => 'present',
        'path'    => 'HKLM\System\CurrentControlSet\Services\run_windows_stuff\ErrorControl',
        'data'		=> 0x00000001,
        'type'		=> 'dword',
      ).that_requires('Registry_key[run_windows_stuff]')
      .that_notifies('Reboot[run_windows_stuff_after]')
    }
    
    it {
    	should contain_reboot('run_windows_stuff_after').with(
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
  		).that_comes_before('Registry_key[run_windows_stuff]')
  	}    
  	
  	it {
      should contain_registry_key('run_windows_stuff').with(
        'ensure'  => 'present',
        'path'    => 'HKLM\System\CurrentControlSet\Services\run_windows_stuff',
      )
    }

    it {
      should contain_registry_value('run_windows_stuff_reg_displayname').with(
        'ensure'  => 'present',
        'path'    => 'HKLM\System\CurrentControlSet\Services\run_windows_stuff\DisplayName',
        'data'		=> 'run_windows_stuff',
        'type'		=> 'string',
      ).that_requires('Registry_key[run_windows_stuff]')
      .that_notifies('Reboot[run_windows_stuff_after]')
    }

    it {
      should contain_registry_value('run_windows_stuff_reg_start').with(
        'ensure'  => 'present',
        'path'    => 'HKLM\System\CurrentControlSet\Services\run_windows_stuff\Start',
        'data'		=> '2',
        'type'		=> 'dword',
      ).that_requires('Registry_key[run_windows_stuff]')
      .that_notifies('Reboot[run_windows_stuff_after]')
    }

    it {
      should contain_registry_value('run_windows_stuff_reg_command').with(
        'ensure'  => 'present',
        'path'    => 'HKLM\System\CurrentControlSet\Services\run_windows_stuff\ImagePath',
        'data'		=> 'C:\Windows\regedit.exe',
        'type'		=> 'string',
      ).that_requires('Registry_key[run_windows_stuff]')
      .that_notifies('Reboot[run_windows_stuff_after]')
    }

    it {
      should contain_registry_value('run_windows_stuff_reg_user').with(
        'ensure'  => 'present',
        'path'    => 'HKLM\System\CurrentControlSet\Services\run_windows_stuff\ObjectName',
        'data'		=> 'testUser',
        'type'		=> 'string',
      ).that_requires('Registry_key[run_windows_stuff]')
      .that_notifies('Reboot[run_windows_stuff_after]')
    }

    it {
      should contain_registry_value('run_windows_stuff_reg_type').with(
        'ensure'  => 'present',
        'path'    => 'HKLM\System\CurrentControlSet\Services\run_windows_stuff\Type',
        'data'		=> 0x00000010,
        'type'		=> 'dword',
      ).that_requires('Registry_key[run_windows_stuff]')
      .that_notifies('Reboot[run_windows_stuff_after]')
    }

    it {
      should contain_registry_value('run_windows_stuff_reg_error').with(
        'ensure'  => 'present',
        'path'    => 'HKLM\System\CurrentControlSet\Services\run_windows_stuff\ErrorControl',
        'data'		=> 0x00000001,
        'type'		=> 'dword',
      ).that_requires('Registry_key[run_windows_stuff]')
      .that_notifies('Reboot[run_windows_stuff_after]')
    }
    
    it {
    	should contain_reboot('run_windows_stuff_after').with(
    		'apply'		=> 'finished',
    		'timeout'	=> '10',
    	)
    }
  end
end

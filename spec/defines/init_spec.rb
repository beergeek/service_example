require 'spec_helper'
describe 'r10k' do
	let(:facts) {
		{
			:osfamily 									=> 'windows',
			:operatingsystem						=> 'windows',
			:operatingsystemmajrelease	=> '6',
			:operatingsystemrelease			=> '6.3.9600',
		}
	}
	let(:title) { 'run_windows_stuff' }

	context 'runs with defaults, plus the script parameters' do
		let(:params) {
			{
				:display_name	=> 'run_windows_stuff'
				:command			=> 'C:\Windows\regedit.exe',
			}
		}
	
		it {
			should contain registry__service('run_windows_stuff_service').with(
				'ensure'				=> 'present',
				'display_name'	=> 'run_windows_stuff',
				'command'				=> 'C:\Windows\regedit.exe',
			)
		}
	end
end
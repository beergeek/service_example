# Class: service_example
#
# This module manages service_example
#
# Parameters:
#
# [*command*]
#   The command to execute for the service.
#   Required.
#
# [*ensure*]
#   Value to determine if the service and user (if included) are present or absent.
#   Values: 'present' or 'absent'.
#   Defaults to 'present'.
#
# [*display_name*]
#   Display name for the service.
#   Defaults to title of the resource.
#
# [*manage_user*]
#   Value to determine if a user is managed for the service.
#   Defaults to false.
#
# [*password*]
#   Password string for user, must be provided if 'mange_user' is true.
#
# [*start*]
#   Value to determine if the service is started.
#   Valid values: 'automatic', 'manual', and 'disabled'.
#   Defaults to 'automatic'.
#
# [*user_name*]
#   Name of the user to manage.
#   If present (even without 'manage_user') the user will be the Service user.
#   Required if 'manage_user' is true.
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
define service_example (
  $command,
  $ensure       = present,
  $display_name = $title,
  $manage_user  = false,
  $password     = undef,
  $start        = 'automatic',
  $user_name    = undef,
) {

  if ! member(['present','absent'],$ensure) {
    fail("The value for \$ensure must be 'present' or 'absent'.....not ${ensure}")
  }
    
  if ! member(['automatic','manual','disabled'], $start) {
    fail("The value for \$start must be 'automatic','manual', or 'disabled'.....not ${start}")
  }

  case $start {
    'automatic': { $start_value = '2' }
    'manual': { $start_value = '3' }
    'disabled': { $start_value = '4' }
    default: { $start_value = '2' }
  }

  $reg_path = "HKLM\\System\\CurrentControlSet\\Services\\${title}"

  Registry_value {
    notify  => Reboot["${title}_after"],
    require => Registry_key[$title],
  }

  registry_key { $title:
    ensure => $ensure,
    path   => "HKLM\\System\\CurrentControlSet\\Services\\${title}",
  }

  if $manage_user {
    if ! $user_name {
      fail('You must provide a $user_name to manage a user')
    }
    if ! $password {
      fail('You must provide a $password to manage a user')
    }
    
    user { "${title}_user":
      ensure    => $ensure,
      name      => $user_name,
      password  => $password,
      before    => Registry_key[$title],
    }
  }
  
  if $user_name {
    registry_value { "${title}_reg_user":
      ensure  => $ensure,
      path    => "${reg_path}\\ObjectName",
      data    => $user_name,
      type    => 'string',
    }
  }

  registry_value { "${title}_reg_displayname":
    ensure  => $ensure,
    path    => "${reg_path}\\DisplayName",
    data    => $display_name,
    type    => 'string',
  }

  registry_value { "${title}_reg_start":
    ensure  => $ensure,
    path    => "${reg_path}\\Start",
    data    => $start_value,
    type    => 'dword',
  }

  registry_value { "${title}_reg_command":
    ensure  => $ensure,
    path    => "${reg_path}\\ImagePath",
    data    => $command,
    type    => 'string',
  }

  registry_value { "${title}_reg_type":
    ensure  => $ensure,
    path    => "${reg_path}\\Type",
    data    => 0x00000010,
    type    => 'dword',
  }

  registry_value { "${title}_reg_error":
    ensure  => $ensure,
    path    => "${reg_path}\\ErrorControl",
    data    => 0x00000001,
    type    => 'dword',
  }

  reboot { "${title}_after":
    apply   => 'finished',
    timeout => '10',
  }
}

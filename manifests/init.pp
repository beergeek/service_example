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
  $start        = 'automatic',
  $user_name    = undef,
) {

  if ! member(['present','absent'],$ensure) {
    fail("The value for \$ensure must be 'present' or 'absent'.....not ${ensure}")
  }
    
  if ! member(['automatic','manual','disabled'], $start) {
    fail("The value for \$start must be 'automatic','manual', or 'disabled'.....not ${start}")
  }

  if $manage_user {
    if ! $user_name {
      fail('You must provide a $user_name to manage a user')
    }
    
    user { "${title}_user":
      ensure => $ensure,
      name   => $user_name,
      before => Registry::Service["${title}"],
    }
  }
  
  if $user_name {
    registry::value { "${title}_reg":
      key   => "HKLM\System\CurrentControlSet\services\${title}\ObjectName",
      type  => 'string',
      value => $user_name,
    }
  }

  registry::service { "${title}":
    ensure        => $ensure,
    display_name  => $display_name,
    command       => $command,
    start         => $start,
  }
}

# Class: service_example
#
# This module manages service_example
#
# Parameters: none
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
  $user_name    = undef,
  $start        = 'automatic',
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
    }
   }

  registry::service { "${title}_service":
    ensure        => $ensure,
    display_name  => $display_name,
    command       => $command,
    start         => $start,
  }
}

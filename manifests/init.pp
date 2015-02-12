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
) {

  registry::service { "${title}_service":
    ensure        => $ensure,
    display_name  => $display_name,
    command       => $command,
  }
}

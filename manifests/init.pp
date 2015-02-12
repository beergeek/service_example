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

  if ! member(['automatic','manual','disabled'], $start) {
    fail("The value for \$start must be 'automatic','manual', or 'disabled'.....not ${start}")
  }

  registry::service { "${title}_service":
    ensure        => $ensure,
    display_name  => $display_name,
    command       => $command,
    start         => $start,
  }
}

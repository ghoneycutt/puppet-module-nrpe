# == Define: nrpe::plugin
#
# Manage a file to be included from include_dir configuration in nrpe.cfg that
# does a remote check.
#
# command[check_hda1]=@libexecdir@/check_disk -w 20% -c 10% -p /dev/hda1
# command[$name]=$libexecdir/$plugin $args
define nrpe::plugin (
  $ensure     = 'present',
  $args       = 'UNSET',
  $libexecdir = 'USE_DEFAULTS',
  $plugin     = 'USE_DEFAULTS',
) {

  validate_re($ensure,'^(present)|(absent)$',
    "nrpe::plugin::${name}::ensure must be 'present' or 'absent'. Detected value is <${ensure}>.")

  if $ensure == 'present' {
    $plugin_ensure = 'file'
  } else {
    $plugin_ensure = 'absent'
  }

  include nrpe

  if $plugin == 'USE_DEFAULTS' {
    $plugin_real = $name
  } else {
    $plugin_real = $plugin
  }

  if $libexecdir == 'USE_DEFAULTS' {
    $libexecdir_real = $nrpe::libexecdir_real
  } else {
    $libexecdir_real = $libexecdir
  }

  validate_absolute_path($libexecdir_real)

  file { "nrpe_plugin_${name}":
    ensure  => $plugin_ensure,
    path    => "${nrpe::include_dir_real}/${name}.cfg",
    content => template('nrpe/plugin.erb'),
    owner   => $nrpe::nrpe_config_owner,
    group   => $nrpe::nrpe_config_group,
    mode    => $nrpe::nrpe_config_mode,
    require => File['nrpe_config_dot_d'],
    notify  => Service['nrpe_service'],
  }
}

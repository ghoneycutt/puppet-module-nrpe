# == Define: nrpe::rawcfg
#
# Manage a file to be included from include_dir configuration in nrpe.cfg
# that contains user supplied raw data (some might prefer to supply the
# baseline this way if they have very many checks). Puppet will of course
# only be able to do very basic sanity checks.
# 
#
define nrpe::rawcfg (
  $ensure     = 'present',
  $content    = 'UNSET',
) {

  validate_re($ensure,'^(present)|(absent)$',
    "nrpe::rawcfg::${name}::ensure must be 'present' or 'absent'. Detected value is <${ensure}>.")

  if $ensure == 'present' {
    $rawcfg_ensure = 'file'
  } else {
    $rawcfg_ensure = 'absent'
  }

  include ::nrpe

  file { "nrpe_rawcfg_${name}":
    ensure  => $rawcfg_ensure,
    path    => "${nrpe::include_dir_real}/${name}.cfg",
    content => template('nrpe/rawcfg.erb'),
    owner   => $nrpe::nrpe_config_owner,
    group   => $nrpe::nrpe_config_group,
    mode    => $nrpe::nrpe_config_mode,
    require => File['nrpe_config_dot_d'],
    notify  => Service['nrpe_service'],
  }


}

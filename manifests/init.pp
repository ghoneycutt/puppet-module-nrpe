# == Class: nrpe
#
# Module to manage nrpe
#
class nrpe (
  $nrpe_package                     = 'USE_DEFAULTS',
  $nrpe_package_adminfile           = 'USE_DEFAULTS',
  $nrpe_package_source              = 'USE_DEFAULTS',
  $nagios_plugins_package           = 'USE_DEFAULTS',
  $nagios_plugins_package_adminfile = 'USE_DEFAULTS',
  $nagios_plugins_package_source    = 'USE_DEFAULTS',
  $nrpe_config                      = 'USE_DEFAULTS',
  $nrpe_config_owner                = 'root',
  $nrpe_config_group                = 'root',
  $nrpe_config_mode                 = '0644',
  $libexecdir                       = 'USE_DEFAULTS',
  $log_facility                     = 'daemon',
  $pid_file                         = 'USE_DEFAULTS',
  $server_port                      = '5666',
  $server_address_enable            = false,
  $server_address                   = '127.0.0.1',
  $nrpe_user                        = 'USE_DEFAULTS',
  $nrpe_group                       = 'USE_DEFAULTS',
  $allowed_hosts                    = ['127.0.0.1'],
  $dont_blame_nrpe                  = '0',
  $allow_bash_command_substitution  = '0',
  $command_prefix_enable            = false,
  $command_prefix                   = '/usr/bin/sudo',
  $debug                            = '0',
  $command_timeout                  = '60',
  $connection_timeout               = '300',
  $allow_weak_random_seed           = '0',
  $include_dir                      = 'USE_DEFAULTS',
  $service_ensure                   = 'running',
  $service_name                     = 'USE_DEFAULTS',
  $service_enable                   = true,
  $plugins                          = undef,
  $purge_plugins                    = false,
  $hiera_merge_plugins              = true,
) {

  # OS platform defaults
  case $::osfamily {
    'RedHat': {
      $default_service_name                     = 'nrpe'
      $default_nrpe_package                     = 'nrpe'
      $default_nrpe_package_adminfile           = undef
      $default_nrpe_package_source              = undef
      $default_nagios_plugins_package           = 'nagios-plugins'
      $default_nagios_plugins_package_adminfile = undef
      $default_nagios_plugins_package_source    = undef
      $default_nrpe_config                      = '/etc/nagios/nrpe.cfg'
      $default_pid_file                         = '/var/run/nrpe/nrpe.pid'
      $default_nrpe_user                        = 'nrpe'
      $default_nrpe_group                       = 'nrpe'
      $default_include_dir                      = '/etc/nrpe.d'

      if $::architecture == 'i386' {
        $default_libexecdir          = '/usr/lib/nagios/plugins'
      } else {
        $default_libexecdir          = '/usr/lib64/nagios/plugins'
      }
    }
    'Suse': {
      $default_nrpe_package                     = 'nagios-nrpe'
      $default_nrpe_package_adminfile           = undef
      $default_nrpe_package_source              = undef
      $default_nagios_plugins_package           = 'nagios-plugins'
      $default_nagios_plugins_package_adminfile = undef
      $default_nagios_plugins_package_source    = undef
      $default_nrpe_config                      = '/etc/nagios/nrpe.cfg'
      $default_libexecdir                       = '/usr/lib/nagios/plugins'
      $default_pid_file                         = '/var/run/nrpe/nrpe.pid'
      $default_nrpe_user                        = 'nagios'
      $default_nrpe_group                       = 'nagios'
      $default_include_dir                      = '/etc/nrpe.d'
      $default_service_name                     = 'nrpe'
    }
    'Solaris': {
      $default_service_name                     = 'nrpe'
      $default_nrpe_package                     = 'nrpe'
      $default_nrpe_package_adminfile           = undef
      $default_nrpe_package_source              = undef
      $default_nagios_plugins_package           = 'nagios-plugins'
      $default_nagios_plugins_package_adminfile = undef
      $default_nagios_plugins_package_source    = undef
      $default_nrpe_config                      = '/usr/local/nagios/etc/nrpe.cfg'
      $default_libexecdir                       = '/usr/local/nagios/libexec'
      $default_pid_file                         = '/var/run/nagios/nrpe.pid'
      $default_nrpe_user                        = 'nagios'
      $default_nrpe_group                       = 'nagios'
      $default_include_dir                      = '/usr/local/nagios/etc/nrpe.d'
    }
    'Debian': {
      case $::lsbdistid {
        'Ubuntu': {
          $default_service_name                     = 'nagios-nrpe-server'
          $default_nrpe_package                     = 'nagios-nrpe-server'
          $default_nrpe_package_adminfile           = undef
          $default_nrpe_package_source              = undef
          $default_nagios_plugins_package           = 'nagios-plugins-basic'
          $default_nagios_plugins_package_adminfile = undef
          $default_nagios_plugins_package_source    = undef
          $default_nrpe_config                      = '/etc/nagios/nrpe.cfg'
          $default_libexecdir                       = '/usr/lib/nagios/plugins'
          $default_pid_file                         = '/var/run/nagios/nrpe.pid'
          $default_nrpe_user                        = 'nagios'
          $default_nrpe_group                       = 'nagios'
          $default_include_dir                      = '/etc/nagios/nrpe.d'
        }
        default: {
          fail("nrpe supports lsbdistid Ubuntu in the osfamily Debian. Detected operatingsystem is <${::lsbdistid}>.")
        }
      }
    }
    default: {
      fail("nrpe supports RedHat, Suse, Solaris and Ubuntu. Detected osfamily is <${::osfamily}>.")
    }
  }

  # Use defaults if a value was not specified in Hiera.
  if $service_name == 'USE_DEFAULTS' {
    $service_name_real = $default_service_name
  } else {
    $service_name_real = $service_name
  }

  if $nrpe_package == 'USE_DEFAULTS' {
    $nrpe_package_real = $default_nrpe_package
  } else {
    $nrpe_package_real = $nrpe_package
  }

  if type($nrpe_package_real) != 'String' and type($nrpe_package_real) != 'Array' {
    fail('nrpe::nrpe_package must be a string or an array.')
  }

  if $nrpe_package_adminfile == 'USE_DEFAULTS' {
    $nrpe_package_adminfile_real = $default_nrpe_package_adminfile
  } else {
    $nrpe_package_adminfile_real = $nrpe_package_adminfile
  }

  if $nrpe_package_source == 'USE_DEFAULTS' {
    $nrpe_package_source_real = $default_nrpe_package_source
  } else {
    $nrpe_package_source_real = $nrpe_package_source
  }

  if $nagios_plugins_package == 'USE_DEFAULTS' {
    $nagios_plugins_package_real = $default_nagios_plugins_package
  } else {
    $nagios_plugins_package_real = $nagios_plugins_package
  }

  if type($nagios_plugins_package_real) != 'String' and type($nagios_plugins_package_real) != 'Array' {
    fail('nrpe::nagios_plugins_package must be a string or an array.')
  }

  if $nagios_plugins_package_adminfile == 'USE_DEFAULTS' {
    $nagios_plugins_package_adminfile_real = $default_nagios_plugins_package_adminfile
  } else {
    $nagios_plugins_package_adminfile_real = $nagios_plugins_package_adminfile
  }

  if $nagios_plugins_package_source == 'USE_DEFAULTS' {
    $nagios_plugins_package_source_real = $default_nagios_plugins_package_source
  } else {
    $nagios_plugins_package_source_real = $nagios_plugins_package_source
  }

  if $nrpe_config == 'USE_DEFAULTS' {
    $nrpe_config_real = $default_nrpe_config
  } else {
    $nrpe_config_real = $nrpe_config
  }

  if $libexecdir == 'USE_DEFAULTS' {
    $libexecdir_real = $default_libexecdir
  } else {
    $libexecdir_real = $libexecdir
  }

  if $pid_file == 'USE_DEFAULTS' {
    $pid_file_real = $default_pid_file
  } else {
    $pid_file_real = $pid_file
  }

  if $nrpe_user == 'USE_DEFAULTS' {
    $nrpe_user_real = $default_nrpe_user
  } else {
    $nrpe_user_real = $nrpe_user
  }

  if $nrpe_group == 'USE_DEFAULTS' {
    $nrpe_group_real = $default_nrpe_group
  } else {
    $nrpe_group_real = $nrpe_group
  }

  if $include_dir == 'USE_DEFAULTS' {
    $include_dir_real = $default_include_dir
  } else {
    $include_dir_real = $include_dir
  }

  # Convert types
  if type($server_address_enable) == 'string' {
    $server_address_enable_bool = str2bool($server_address_enable)
  } else {
    $server_address_enable_bool = $server_address_enable
  }

  if type($command_prefix_enable) == 'string' {
    $command_prefix_enable_bool = str2bool($command_prefix_enable)
  } else {
    $command_prefix_enable_bool = $command_prefix_enable
  }

  if type($service_enable) == 'string' {
    $service_enable_bool = str2bool($service_enable)
  } else {
    $service_enable_bool = $service_enable
  }

  if type($purge_plugins) == 'string' {
    $purge_plugins_bool = str2bool($purge_plugins)
  } else {
    $purge_plugins_bool = $purge_plugins
  }

  if type($hiera_merge_plugins) == 'string' {
    $hiera_merge_plugins_bool = str2bool($hiera_merge_plugins)
  } else {
    $hiera_merge_plugins_bool = $hiera_merge_plugins
  }

  # Validate params
  validate_re($nrpe_config_mode, '^\d{4}$',
    "nrpe::nrpe_config_mode must be a four digit octal mode. Detected value is <${nrpe_config_mode}>.")
  validate_absolute_path($nrpe_config_real)
  validate_absolute_path($libexecdir_real)
  validate_absolute_path($pid_file_real)
  validate_re($server_port, '^\d+$',
    "nrpe::server_port must be a valid port number between 0 and 65535, inclusive. Detected value is <${server_port}>.")
  if $server_port < 0 or $server_port > 65535 {
    fail("nrpe::server_port must be a valid port number between 0 and 65535, inclusive. Detected value is <${server_port}>.")
  }
  validate_array($allowed_hosts)
  validate_re($dont_blame_nrpe, '^[01]{1}$',
    "nrpe::dont_blame_nrpe must be 0 or 1. Detected value is <${dont_blame_nrpe}>.")
  validate_re($allow_bash_command_substitution, '^[01]{1}$',
    "nrpe::allow_bash_command_substitution must be 0 or 1. Detected value is <${allow_bash_command_substitution}>.")
  validate_absolute_path($command_prefix)
  validate_re($debug, '^[01]{1}$',
    "nrpe::debug must be 0 or 1. Detected value is <${debug}>.")
  validate_re($command_timeout, '^\d+$',
    "nrpe::command_timeout must be a postive integer. Detected value is <${command_timeout}>.")
  validate_re($connection_timeout, '^\d+$',
    "nrpe::connection_timeout must be a postive integer. Detected value is <${connection_timeout}>.")
  validate_re($allow_weak_random_seed, '^[01]{1}$',
    "nrpe::allow_weak_random_seed must be 0 or 1. Detected value is <${allow_weak_random_seed}>.")
  validate_absolute_path($include_dir_real)
  validate_re($service_ensure, '^(running|stopped)$',
    "nrpe::service_ensure must be \'running\' or \'stopped\'. Detected value is <${service_ensure}>.")

  package { $nrpe_package_real:
    ensure    => 'present',
    adminfile => $nrpe_package_adminfile_real,
    source    => $nrpe_package_source_real,
  }

  package { $nagios_plugins_package_real:
    ensure    => 'present',
    adminfile => $nagios_plugins_package_adminfile_real,
    source    => $nagios_plugins_package_source_real,
    before    => Service['nrpe_service'],
  }

  file { 'nrpe_config':
    ensure  => file,
    content => template('nrpe/nrpe.cfg.erb'),
    path    => $nrpe_config_real,
    owner   => $nrpe_config_owner,
    group   => $nrpe_config_group,
    mode    => $nrpe_config_mode,
    require => Package[$nrpe_package_real],
  }

  file { 'nrpe_config_dot_d':
    ensure  => directory,
    path    => $include_dir_real,
    owner   => $nrpe_config_owner,
    group   => $nrpe_config_group,
    mode    => $nrpe_config_mode,
    purge   => $purge_plugins_bool,
    recurse => true,
    require => Package[$nrpe_package_real],
    notify  => Service['nrpe_service'],
  }

  service { 'nrpe_service':
    ensure    => $service_ensure,
    name      => $service_name_real,
    enable    => $service_enable_bool,
    subscribe => File['nrpe_config'],
  }

  if $plugins != undef {
    if $hiera_merge_plugins_bool {
      $plugins_real = hiera_hash('nrpe::plugins')
    } else {
      $plugins_real = $plugins
    }
    validate_hash($plugins_real)
    create_resources('nrpe::plugin',$plugins_real)
  }
}

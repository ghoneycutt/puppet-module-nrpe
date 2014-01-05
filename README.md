# puppet-module-nrpe
===

[![Build Status](https://travis-ci.org/ghoneycutt/puppet-module-nrpe.png?branch=master)](https://travis-ci.org/ghoneycutt/puppet-module-nrpe)

Manage NRPE

===

# Compatibility
---------------
This module is built for use with Puppet v3 and is tested on the following OS families.

* EL 6
* Suse 11

===

# Class `nrpe`

## Parameters

nrpe_package
------------
Name of package(s) for NRPE.

- *Default*: based on OS platform.

nrpe_package_adminfile
----------------------
Path to admin file for NRPE package.

- *Default*: based on OS platform. (used on Solaris)

nrpe_package_source
-------------------
Source to NRPE package.

- *Default*: based on OS platform. (used on Solaris)

nagios_plugins_package
----------------------
Name of package(s) for nagios-plugins.

- *Default*: based on OS platform.

nagios_plugins_package_adminfile
--------------------------------
Path to admin file for nagios-plugins package.

- *Default*: based on OS platform. (used on Solaris)

nagios_plugins_package_source
-----------------------------
Source to nagios-plugins package.

- *Default*: based on OS platform. (used on Solaris)

nrpe_config
-----------
Path to nrpe.cfg file.

- *Default*: based on OS platform.

nrpe_config_owner
-----------------
Owner of nrpe.cfg file.

- *Default*: 'root'

nrpe_config_group
-----------------
Group of nrpe.cfg file.

- *Default*: 'root'

nrpe_config_mode
----------------
Mode of nrpe.cfg file.

- *Default*: '0644'

libexecdir
----------
Directory in which nrpe plugins are stored.

- *Default*: based on OS platform.

log_facility
------------
The syslog facility that should be used for logging purposes.

- *Default*: 'daemon'

pid_file
--------
File in which the NRPE daemon should write it's process ID number.

- *Default*: based on OS platform.

server_port
-----------
Port number for nrpe.

- *Default*: '5666'

server_address_enable
---------------------
Boolean to include server_address in nrpe.cfg.

- *Default*: false

server_address
--------------
Address that nrpe should bind to in case there are more than one interface and you do not want nrpe to bind on all interfaces.

- *Default*: '127.0.0.1'

nrpe_user
---------
This determines the effective user that the NRPE daemon should run as.

- *Default*: based on OS platform

nrpe_group
---------
This determines the effective group that the NRPE daemon should run as.

- *Default*: based on OS platform

allowed_hosts
-------------
Array of IP address or hostnames that are allowed to talk to the NRPE daemon.

- *Default*: ['127.0.0.1']

dont_blame_nrpe
---------------
This option determines whether or not the NRPE daemon will allow clients to specify arguments to commands that are executed. 0=do not allow arguments, 1=allow command arguments.

- *Default*: '0'

allow_bash_command_substitution
-------------------------------
Determines whether or not the NRPE daemon will allow clients to specify arguments that contain bash command substitutions. 0=do not allow, 1=allow. Allowing is a **HIGH SECURITY RISK**.

- *Default*: '0'

command_prefix_enable
---------------------
Boolean to include command_prefix in nrpe.cfg.

- *Default*: false

command_prefix
--------------
Prefix all commands with a user-defined string. Must be a fully qualified path.

- *Default*: '/usr/bin/sudo'

debug
-----
If debugging messages are logged to the syslog facility. Values: 0=debugging off, 1=debugging on

- *Default*: '0'

command_timeout
---------------
Maximum number of seconds that the NRPE daemon will allow plugins to finish executing before killing them off.

- *Default*: '60'

connection_timeout
------------------
Maximum number of seconds that the NRPE daemon will wait for a connection to be established before exiting.

- *Default*: '300'

allow_weak_random_seed
----------------------
Allows SSL even if your system does not have a /dev/random or /dev/urandom. Values: 0=only seed from /dev/[u]random, 1=also seed from weak randomness

- *Default*: '0'

include_dir
-----------
Include definitions from config files (with a .cfg extension) recursively from specified directory.

- *Default*: based on OS platform.

service_ensure
--------------
Value of ensure parameter for nrpe service. Valid values are 'running' and 'stopped'.

- *Default*: 'running'

service_name
--------------
Value of name parameter for nrpe service.

- *Default*: 'nrpe'

service_enable
--------------
Boolean value of enable parameter for nrpe service.

- *Default*: true

plugins
-------
Hash of plugins to be passed to nrpe::plugin with create_resources().

- *Default*: undef

===

# Define `nrpe::plugin`

Creates a fragment in the sudoers.d directory with `$name.cfg`. Each matches the following layout, where `$args` are optional.

<pre>
command[$name]=${libexecdir}/${plugin} $args
</pre>

## Usage
You can optionally specify a hash of nrpe plugins in Hiera.

<pre>
---
nrpe::plugins:
  check_root_partition:
    plugin: 'check_disk'
    libexecdir: '/usr/lib64/nagios/plugins'
    args: '-w 20% -c 10% -p /'
  check_load:
    args: '-w 10,8,8 -c 12,10,9'
  check_myapp:
</pre>

## Parameters

ensure
------
Ensure the plugin exists. Valid values are `present` and `absent`.

- *Default*: present

args
----
Arguments to pass to the plugin.

- *Defaul*: undef

libexecdir
----------
Directory in which nrpe plugin is stored.

- *Default*: $nrpe::libexecdir, which is based on OS platform.

plugin
------
Name of the plugin to be executed.

- *Default*: $name

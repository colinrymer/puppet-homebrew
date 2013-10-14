# Public: Install and configure homebrew for use with Boxen.
#
# Examples
#
#   include homebrew

class homebrew(
  $cachedir   = $homebrew::config::cachedir,
  $installdir = $homebrew::config::installdir,
  $libdir     = $homebrew::config::libdir,
  $cmddir     = $homebrew::config::cmddir,
  $tapsdir    = $homebrew::config::tapsdir,
  $brewsdir   = $homebrew::config::brewsdir,
) inherits homebrew::config {
  include boxen::config
  include homebrew::repo

  repository { $installdir:
    source => 'mxcl/homebrew',
    user   => $::boxen_user,
    require => Exec['chmod_installdir']
  }

  exec { 'chmod_installdir':
    command => "mkdir -p /usr/local; /bin/chmod g+rwx $installdir; /usr/bin/chgrp admin $installdir",
    unless => "test `stat -f %g $installdir` -eq `grep ^admin: /etc/group | cut -d: -f3`",
    user => root
  }

  File {
    require => Repository[$installdir]
  }

  file {
    [$cachedir, $tapsdir, $cmddir, $libdir]:
      ensure => 'directory' ;

    # Environment Variables
    "${boxen::config::envdir}/homebrew.sh":
      content => template('homebrew/env.sh.erb') ;

    # shim for monkeypatches
    "${cmddir}/boxen-latest.rb":
      source  => 'puppet:///modules/homebrew/boxen-latest.rb' ;
  }
}

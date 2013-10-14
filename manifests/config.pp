# Public: Variables for working with Homebrew
#
# Examples
#
#   require homebrew::config

class homebrew::config {
  include boxen::config

  $cachedir   = "${boxen::config::cachedir}/homebrew"
  $installdir = "/usr/local"
  $libdir     = "${installdir}/lib"

  $cmddir     = "${installdir}/Library/Homebrew/cmd"
  $tapsdir    = "${installdir}/Library/Taps"

  $brewsdir   = "${tapsdir}/boxen-brews"
}

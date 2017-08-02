class vagrant_boxes::install(
  $version = '1.9.7'
) {
  $base_url = 'https://releases.hashicorp.com/vagrant'

  case $::operatingsystem {
    'opensuse': {
      case $::architecture {
        'x86_64', 'amd64': {
          $vagrant_source = "${base_url}/${version}/vagrant_${version}_x86_64.rpm"
          $vagrant_provider = 'rpm'
        }
        'i386': {
          $vagrant_source = "${base_url}/${version}/vagrant_${version}_i686.rpm"
          $vagrant_provider = 'rpm'
        }
        default: {
          fail("Unrecognized architecture: ${::architecture} on ${::operatingsystem}")
        }
      }
    }
    default: {
      fail("Unrecognized operating system: ${::operatingsystem}")
    }
  }

  package { "vagrant":
    ensure   => present,
    provider => $vagrant_provider,
    source   => $vagrant_source
  }
}
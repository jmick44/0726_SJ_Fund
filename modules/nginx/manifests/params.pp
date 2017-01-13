class nginx::params {
  case $::osfamily {
    'RedHat','Debian': {
      $package  = 'nginx'
      $owner    = 'root'
      $group    = 'root'
      $docroot  = '/var/www'
      $confdir  = '/etc/nginx'
      $blockdir = '/etc/nginx/conf.d'
      $logdir   = '/var/log/nginx'
      $service  = 'nginx'
    }
    default : {
      fail("This module is not supported on ${::osfamily}")
    }
  }

  $user = $::osfamily ? {
    'RedHat' => 'nginx',
    'Debian' => 'www-data',
    default  => 'fail',
  }

  if $user == 'fail' {
    fail("This module is not suppported on ${::osfamily}")
  }
}

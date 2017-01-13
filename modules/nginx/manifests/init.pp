class nginx (
  $message   = "Message default from nginx class",
  $package   = $nginx::params::package,
  $owner     = $nginx::params::owner,
  $group     = $nginx::params::group,
  $docroot   = $nginx::params::docroot,
  $confdir   = $nginx::params::confdir,
  $blockdir  = $nginx::params::blockdir,
  $logdir    = $nginx::params::logdir,
  $user      = $nginx::params::user
) inherits nginx::params {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0775'
  }

  notify { "$message": }

  package { $package:
    ensure => present,
    before => [File["${blockdir}/default.conf"],File["${confdir}/nginx.conf"]],
  }

  file { $docroot:
    ensure => directory,
  }

  file { "${docroot}/index.html":
    ensure  => file,
    #source => 'puppet:///modules/nginx/index.html',
    content => epp('nginx/index.html.epp'),
  }

  service { $service:
    ensure    => running,
    enable    => true,
    subscribe => [
                   File["${confdir}/nginx.conf"],
                   File["${blockdir}/default.conf"]
                 ],
  }

  file { "${confdir}/nginx.conf":
    ensure   => file,
    mode     => '0664',
    #source  => 'puppet:///modules/nginx/nginx.conf',
    content  => epp('nginx/nginx.conf.epp',
                    {
                      user     => $user,
                      logdir   => $logdir,
                      confdir  => $confdir,
                      blockdir => $blockdir,
                    }),
    #require => Package['nginx'],
    #notify  => Service['nginx'],
  }

  file { "${blockdir}/default.conf":
    ensure  => file,
    source  => 'puppet:///modules/nginx/default.conf',
    #require => Package['nginx'],
    #notify  => Service['nginx'],
  }

  nginx::vhost { 'misspiggy.puppet.com':
    docroot => $docroot,
    user    => 'misspiggy',
  }

  nginx::vhost { 'oscar.puppet.com':
    docroot => '/var/www',
    user    => 'oscar',
    port    => '8080',
  }
}

 

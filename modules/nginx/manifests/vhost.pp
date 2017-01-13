define nginx::vhost (
  $docroot,
  $port = '80',
  $user,
){

  file { "${docroot}/${title}":
    ensure => directory,
  }

  file { "${docroot}/${title}/${title}.conf":
    ensure  => file,
    content => "port = ${port}",
  }

  user { $user:
    ensure => present,
  }

}

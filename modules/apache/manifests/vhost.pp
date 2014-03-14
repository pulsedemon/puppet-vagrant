define apache::vhost  (
  $content = '' ,
  $ensure  = present) {

  $manage_file_content = $content ? {
    ''        => undef,
    default   => $content,
  }

  file { "Apache_${name}.conf":
    ensure  => $ensure,
    path    => "/etc/apache2/sites-available/${name}",
    require => Package['apache2'],
    notify => Service['apache2'],
    content => $manage_file_content,
  }

  file { "/etc/apache2/sites-enabled/${name}":
    ensure        => 'link',
    target        => "../sites-available/${name}",
    notify       => Service['apache2'],
  }
}
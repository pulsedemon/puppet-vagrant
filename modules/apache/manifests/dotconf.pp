define apache::dotconf (
  $content = '' ,
  $ensure  = present) {

  $manage_file_content = $content ? {
    ''        => undef,
    default   => $content,
  }

  file { "Apache_${name}.conf":
    ensure  => $ensure,
    path    => "/etc/apache2/conf.d/${name}.conf",
    require => Package['apache2'],
    notify => Service['apache2'],
    content => $manage_file_content,
  }

}
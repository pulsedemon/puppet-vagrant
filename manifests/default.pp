class vim {
  package { "vim":
    ensure => present,
  }
}

class php {
  package { "php5":
    ensure => present,
    require  => Exec['apt-get update'],
  }

  package { "php5-cli":
    ensure => present,
  }

  package { "php5-mysql":
    ensure => present,
  }

  package { "libapache2-mod-php5":
    ensure => present,
  }
}

class mysql {
  package { "mysql-server":
    ensure => present,
    require  => Exec['apt-get update'],
  }

  package { "mysql-client":
    ensure => present,
    require => Package['mysql-server']
  }
}

class capistrano {
  package { 'capistrano':
    ensure   => 'installed',
    provider => 'gem',
  }
}

include apache

class apache::vagrant {
  apache::dotconf { '000-default':
    content => template('apache/000-default.conf.erb'),
  }

  apache::vhost { 'esd.dev':
    content => template('apache/esd.vhost.erb'),
  }

  apache::module { ["rewrite", "headers"]:
    ensure => present,
  }
}

class python {
  package { "python2.7":
    ensure  => latest,
    require  => Exec['apt-get update'],
  }
}

include apache::vagrant

include python
include vim
include php
include mysql
include capistrano
include postfix
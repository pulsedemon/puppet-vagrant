# Define an apache2 module. Debian packages place the module config
# into /etc/apache2/mods-available.
#
# You can add a custom require (string) if the module depends on
# packages that aren't part of the default apache2 package. Because of
# the package dependencies, apache2 will automagically be included.
#
# REVIEW: 20070901 <sq@wesabe.com> -- when facts can be distributed
# within modules (see puppet trac ticket #803), the unless/onlyif clauses
# below should get rewritten to use custom facter facts
define apache::module ( $ensure = 'present') {
  case $ensure {
    'present' : {
      exec { "/usr/sbin/a2enmod $name":
        unless => "/bin/sh -c '[ -L ${apache_mods}-enabled/${name}.load ] \\
          && [ ${apache_mods}-enabled/${name}.load -ef ${apache_mods}-available/${name}.load ]'",
        notify => Service['apache2'],
      }
    }
    'absent': {
      exec { "/usr/sbin/a2dismod $name":
        onlyif => "/bin/sh -c '[ -L ${apache_mods}-enabled/${name}.load ] \\
          && [ ${apache_mods}-enabled/${name}.load -ef ${apache_mods}-available/${name}.load ]'",
        notify => Service['apache2'],
      }
    }
    default: { err ( "Unknown ensure value: '$ensure'" ) }
  }
}
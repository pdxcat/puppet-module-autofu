class autofu {

  case $operatingsystem {
    "Ubuntu": { } # yay!
    default:  { fail("autofu does not support $operatingsystem") }
  }

  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/init/autofu.conf':
    source => "puppet://$server/modules/autofu/autofu.conf",
    notify => [
      Exec['autofu initctl reload-configuration'],
      Service['autofu'],
    ],
  }

  file { '/etc/init.d/autofu':
    content => "#!/bin/sh\n\nservice autofu \$1\n",
  }

  file { '/etc/auto.fu':
    mode   => '644',
    notify => Service['autofu'],
  }

  file { '/usr/local/bin/autofu.sh':
    source => "puppet://$server/modules/autofu/autofu.sh",
  }

  service { 'autofu':
    ensure   => running,
    provider => upstart,
    require  => [
      File['/etc/auto.fu'],
      File['/etc/init/autofu.conf'],
      File['/usr/local/bin/autofu.sh'],
    ],
  }

  exec { 'autofu initctl reload-configuration':
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    command     => 'initctl reload-configuration',
    before      => Service['autofu'],
    refreshonly => true,
  }
}

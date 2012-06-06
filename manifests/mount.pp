define autofu::mount (
  $location,
  $mountpoint = $title,
  $options    = undef
) {
  include autofu

  if $options != undef {
    $nohyphen_options = regsubst($options, '^-', '')
    $hyphen_options   = "-$nohyphen_options"
  } else {
    $hyphen_options = undef
  }

  file_line { "autofu::mount $mountpoint":
    ensure  => present,
    path    => '/etc/auto.fu',
    line    => "$mountpoint $hyphen_options $location",
    require => File['/etc/auto.fu'],
    notify  => Service['autofu'];
  }
}

class creamwn inherits creamwn::params {

  package { ["globus-proxy-utils", "globus-gass-copy-progs", "glite-lb-client-progs" ]: 
    ensure   => present,
    tag      => [ "wnpackages" ],
  }

  
  # ##################################################################################################
  # Pool accounts
  # ##################################################################################################

  $group_table = build_group_definitions($voenv)
  create_resources(group, $group_table)
  
  $user_table = build_user_definitions($voenv, $default_pool_size,
                                       $username_offset, $create_user)
  create_resources(creamwn::pooluser, $user_table)

  notify { "pool_checkpoint":
    message => "Pool groups defined",
  }

  Group <| tag == 'creamce::poolgroup' |> -> Notify["pool_checkpoint"]
  Notify["pool_checkpoint"] -> Creamwn::Pooluser <| |>


  # ##################################################################################################
  # Certificate Authorities
  # ##################################################################################################

  class { "fetchcrl":
    runboot => false,
    runcron => true,
  }

  exec { "initial_fetch_crl":
    command => "/usr/sbin/fetch-crl -l ${cacert_dir} -o ${cacert_dir} || exit 0",
    unless  => "/bin/ls ${cacert_dir}/*.r0",
  }

  Class['fetchcrl'] -> Exec["initial_fetch_crl"]

  # ##################################################################################################
  # Other configurations
  # ##################################################################################################

  file {"/etc/profile.d/grid-env.sh":
    ensure  => present,
    content => "GLITE_LOCATION_VAR=/var
export GLITE_LOCATION_VAR
GLITE_LOCATION=/usr
export GLITE_LOCATION
",
    owner   => "root",
    group   => "root",
    mode    => '0755',
  }  

  file {"/etc/profile.d/grid-env.csh":
    ensure  => present,
    content => "setenv GLITE_LOCATION_VAR=/var
setenv GLITE_LOCATION=/usr
",
    owner   => "root",
    group   => "root",
    mode    => '0644',
  }

  if $glue_2_1 {
    # ldap required by nvidia-smi probe

    group { "ldap":
      ensure   => present,
      gid      => 55,
    }

    user { "ldap":
      ensure   => present,
      gid      => 55,
      require  => Group["ldap"],
    }

  }

}

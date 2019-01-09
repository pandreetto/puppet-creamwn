class creamwn::params {

  $sitename            = lookup({'name' => "creamce::site::name", 'default_value' => "${::fqdn}"})
  $siteemail           = lookup({'name' => "creamce::site::email", 'default_value' => ""})
  $ce_host             = lookup({'name' => "creamce::host", 'default_value' => "${::fqdn}"})
  $ce_port             = lookup({'name' => 'creamce::port', 'default_value' => 8443})
  $ce_type             = lookup({'name' => 'creamce::type', 'default_value' => "cream"})
  $ce_quality_level    = lookup({'name' => 'creamce::quality_level', 'default_value' => "production"})
  $ce_env              = lookup({'name' => 'creamce::environment', 'default_value' => {}})

  $gridenvfile         = lookup({'name' => 'creamce::gridenvfile::sh', 'default_value' => '/etc/profile.d/grid-env.sh'})
  $gridenvcfile        = lookup({'name' => 'creamce::gridenvfile::csh', 'default_value' => '/etc/profile.d/grid-env.csh'})

  $default_pool_size   = lookup({'name' => "creamce::default_pool_size", 'default_value' => 100})
  $username_offset     = lookup({'name' => "creamce::username_offset", 'default_value' => 1})
  $create_user         = lookup({'name' => "creamce::create_user", 'default_value' => true})

  $cream_config_ssh    = lookup({'name' => "creamce::config_ssh", 'default_value' => false})
  $shosts_equiv_extras = lookup({'name' => "creamce::shosts_equiv_extras", 'default_value' => []})
  $ssh_cron_sched      = lookup({'name' => "creamce::ssh_cron_sched", 'default_value' => "05 1,7,13,19 * * *"})

  $cacert_dir          = lookup({'name' => 'creamce::cacert_dir', 'default_value' => '/etc/grid-security/certificates'})
  $crl_update_time     = lookup({'name' => 'creamce::crl_update_time', 'default_value' => 3600})
  $voenv               = lookup({'name' => 'creamce::vo_table', 'default_value' => {}})
  $glue_2_1            = lookup({'name' => 'creamce::info::glue21_draft', 'default_value' => false})

}

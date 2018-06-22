class creamwn::params {

  $sitename                  = hiera("creamce::site::name", "${::fqdn}")
  $siteemail                 = hiera("creamce::site::email", "")
  $ce_host                   = hiera("creamce::host", "${::fqdn}")
  $ce_port                   = hiera('creamce::port', 8443)
  $ce_type                   = hiera('creamce::type', "cream")
  $ce_quality_level          = hiera('creamce::quality_level', "production")
  $ce_env                    = hiera('creamce::environment', {})

  $gridenvfile               = hiera('creamce::gridenvfile::sh','/etc/profile.d/grid-env.sh')
  $gridenvcfile              = hiera('creamce::gridenvfile::csh','/etc/profile.d/grid-env.csh')

  $default_pool_size         = hiera("creamce::default_pool_size", 100)
  $username_offset           = hiera("creamce::username_offset", 1)
  $create_user               = hiera("creamce::create_user", true)

  $cream_config_ssh          = hiera("creamce::config_ssh", false)
  $shosts_equiv_extras       = hiera("creamce::shosts_equiv_extras", [])
  $ssh_cron_sched            = hiera("creamce::ssh_cron_sched", "05 1,7,13,19 * * *")

  $cacert_dir              = hiera('creamce::cacert_dir', '/etc/grid-security/certificates')
  $crl_update_time         = hiera('creamce::crl_update_time',3600)
  $voenv                   = hiera('creamce::vo_table', {})

}

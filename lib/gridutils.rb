module Gridutils

  GROUPS_T =           'groups'
  GROUPS_GID_T =       'gid'
  GROUPS_FQAN_T =      'fqan'

  USERS_T =            'users'
  USERS_FQAN_T =       'fqan'
  USERS_PFQAN_T =      'primary_fqan'
  USERS_SFQAN_T =      'secondary_fqan'
  USERS_PSIZE_T =      'pool_size'
  USERS_CRUSR_T =      'create_user'
  USERS_IDLIST_T =     'uid_list'
  USERS_UTABLE_T =     'users_table'
  USERS_NPATTERN_T =   'name_pattern'
  USERS_FIRSTID_T =    'first_uid'
  USERS_NOFFSET_T =    'name_offset'
  USERS_HOMEDIR_T =    'homedir'
  USERS_SHELL_T =      'shell'
  USERS_CPATTERN_T =   'comment_pattern'
  USERS_PADMIN_T =     'pub_admin'
  USERS_ACCTS_T =      'accounts'
  
  QUEUES_GROUPS_T =    'groups'
  
  VO_SERVERS_T =       'servers'
  VO_SRVNAME_T =       'server'
  VO_SRVPORT_T =       'port'
  VO_SRVDN_T =         'dn'
  VO_SRVCADN_T =       'ca_dn'
  VO_GTVER_T =         'gt_version'
  
  CE_PHYCPU_T =        'ce_physcpu'
  CE_LOGCPU_T =        'ce_logcpu'
  CE_NODES_T =         'nodes'
  CE_RTENV_T =         'ce_runtimeenv'
  CE_CPUMODEL_T =      'ce_cpu_model'
  CE_CPUSPEED_T =      'ce_cpu_speed'
  CE_CPUVEND_T =       'ce_cpu_vendor'
  CE_CPUVER_T =        'ce_cpu_version'
  CE_INCONN_T =        'ce_inboundip'
  CE_OUTCONN_T =       'ce_outboundip'
  CE_PHYMEM_T =        'ce_minphysmem'
  CE_VIRTMEM_T =       'ce_minvirtmem'
  CE_OSFAMILY_T =      'ce_os_family'
  CE_OSNAME_T =        'ce_os_name'
  CE_OSARCH_T =        'ce_os_arch'
  CE_OSREL_T =         'ce_os_release'
  CE_OTHERD_T =        'ce_otherdescr'
  CE_TMPDIR_T =        'subcluster_tmpdir'
  CE_WNTMDIR_T =       'subcluster_wntmdir'
  CE_BENCHM_T =        'ce_benchmarks'
  CE_ACCELER_T =       'accelerators'
  
  BENCH_SPECFP_D =     'specfp2000'
  BENCH_SPECINT_D =    'specint2000'
  BENCH_HEP_D =        'hep-spec06'
  
  USR_STRFMT_D =       '%<prefix>s%03<index>d'

  def Gridutils.norm_fqan(fqan)
    norm_fqan = fqan.lstrip
    norm_fqan.slice!(/\/capability=null/i)
    norm_fqan.slice!(/\/role=null/i)
    norm_fqan.gsub!(/role=/i, "Role=")
    norm_fqan
  end
  
  def Gridutils.get_fqan_table(vodata)

    f_table = Hash.new

    vodata[Gridutils::GROUPS_T].each do | group, gdata |
      gdata[Gridutils::GROUPS_FQAN_T].each do | fqan |

        norm_fqan = Gridutils.norm_fqan(fqan)

        if f_table.has_key?(norm_fqan)
          raise "Duplicate definition of #{norm_fqan} for group #{group}"
        else
          f_table[norm_fqan] = group
        end

      end
    end

    f_table

  end
  
  def Gridutils.is_a_pool(udata, def_pool_size)

    utable = udata.fetch(Gridutils::USERS_UTABLE_T, nil)
    uid_list = udata.fetch(Gridutils::USERS_IDLIST_T, nil)
    pool_size = udata.fetch(Gridutils::USERS_PSIZE_T, def_pool_size)

    (utable != nil and utable.size > 0) or (uid_list != nil and uid_list.size > 0) or pool_size > 0

  end
  
  def Gridutils.format_username(fmt, prefix, idx)

    #sprintf(fmt, { :prefix => prefix, :index => idx })
    vList = Array.new
    fmt2 = fmt.gsub(/%<prefix>s|%\d*\d*<index>d/){ | tmps |
      vList.push(tmps.include?("index") ? idx : prefix)
      tmps.gsub(/<prefix>|<index>/, "")
    }

    fmt2 % vList

  end

  def Gridutils.format_comment(fmt, username, uid)

    #sprintf(fmt, { :username => username, :userid => uid } )
    vList = Array.new
    fmt2 = fmt.gsub(/%<username>s|%\d*\d*<userid>d/){ | tmps |
      vList.push(tmps.include?("username") ? username : uid)
      tmps.gsub(/<username>|<userid>/, "")
    }

    fmt2 % vList

  end

end

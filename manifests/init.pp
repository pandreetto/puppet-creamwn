class creamwn inherits creamwn::params {

  package { ["globus-proxy-utils", "globus-gass-copy-progs", "glite-lb-client-progs" ]: 
    ensure   => present,
    tag      => [ "wnpackages" ],
  }

  
  # ##################################################################################################
  # Pool accounts
  # ##################################################################################################

  define pooluser ($uid, $groups, $comment,
                   $homedir="/home", $shell="/bin/bash", $create_usr=true) {
  
    if $create_usr {
    
      user { "${title}":
        ensure     => "present",
        uid        => $uid,
        gid        => "${groups[0]}",
        groups     => $groups,
        home       => "${homedir}/${title}",
        managehome => true,
        shell      => "${shell}"
      }
      
      unless $comment == "" {
        User["${title}"]{
          comment    => "${comment}",
        }
      }
    
    } else {

      notify { "${title}_fake":
        message => "User ${title} not created",
      }

    }

  }

  $group_table = build_group_definitions($voenv)
  create_resources(group, $group_table)
  
  $user_table = build_user_definitions($voenv, $default_pool_size,
                                       $username_offset, $create_user)
  create_resources(pooluser, $user_table)

  notify { "pool_checkpoint":
    message => "Pool groups defined",
  }

  Group <| tag == 'creamce::poolgroup' |> -> Notify["pool_checkpoint"]
  Notify["pool_checkpoint"] -> Pooluser <| |>

}

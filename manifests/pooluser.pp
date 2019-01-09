define creamwn::pooluser ($uid, $groups, $comment,
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



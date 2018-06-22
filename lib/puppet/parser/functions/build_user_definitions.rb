require 'gridutils'

module Puppet::Parser::Functions
  newfunction(:build_user_definitions, :type => :rvalue, :doc => "This function converts user table structure") do | args |
    voenv = args[0]
    def_pool_size = args[1].to_i()
    def_name_offset = args[2].to_i()
    def_create_user = args[3]

    result = Hash.new

    voenv.each do | voname, vodata |

      f_table = Gridutils.get_fqan_table(vodata)

      vodata[Gridutils::USERS_T].each do | user_prefix, udata |

        grp_list = Array.new

        if udata.fetch(Gridutils::USERS_PFQAN_T, []).length == 0
          raise "Attribute #{Gridutils::USERS_PFQAN_T} is mandatory for #{user_prefix}"
        end

        norm_fqan = Gridutils.norm_fqan(udata[Gridutils::USERS_PFQAN_T][0])
        unless f_table.has_key?(norm_fqan)
          raise "FQAN mismatch with #{norm_fqan} for #{user_prefix}"
        end
        grp_list.push(f_table[norm_fqan])

        udata.fetch(Gridutils::USERS_SFQAN_T, []).each do | fqan |

          norm_fqan = Gridutils.norm_fqan(fqan)
          unless f_table.has_key?(norm_fqan)
            raise "FQAN mismatch with #{norm_fqan} for #{user_prefix}"
          end
          grp_list.push(f_table[norm_fqan])

        end

        home_dir = udata.fetch(Gridutils::USERS_HOMEDIR_T, '/home')
        use_shell = udata.fetch(Gridutils::USERS_SHELL_T, '/bin/bash')
        name_pattern = udata.fetch(Gridutils::USERS_NPATTERN_T, Gridutils::USR_STRFMT_D)
        comment_pattern = udata.fetch(Gridutils::USERS_CPATTERN_T, "")
        name_offset = udata.fetch(Gridutils::USERS_NOFFSET_T, def_name_offset)

        utable = udata.fetch(Gridutils::USERS_UTABLE_T, nil)
        uid_list = udata.fetch(Gridutils::USERS_IDLIST_T, nil)
        pool_size = udata.fetch(Gridutils::USERS_PSIZE_T, def_pool_size)
        create_user = udata.fetch(Gridutils::USERS_CRUSR_T, def_create_user)
        
        if utable != nil and utable.size > 0

          utable.each do | u_name, u_id |
            nDict = { :username => u_name, :userid => u_id }
            commentStr = sprintf(comment_pattern % nDict )
            commentStr = Gridutils.format_comment(comment_pattern, u_name, u_id)
            result[u_name] = {
              'uid'        => u_id,
              'groups'     => grp_list,
              'comment'    => "#{commentStr}",
              'homedir'    => "#{home_dir}",
              'shell'      => "#{use_shell}",
              'create_usr' => create_user
            }
          end

        elsif uid_list != nil and uid_list.size > 0

          (0...uid_list.size).each do | idx |
            nameStr = Gridutils.format_username(name_pattern, user_prefix, idx + name_offset)
            commentStr = Gridutils.format_comment(comment_pattern, nameStr, uid_list.at(idx))
            result[nameStr] = {
              'uid'        => uid_list.at(idx),
              'groups'     => grp_list,
              'comment'    => "#{commentStr}",
              'homedir'    => "#{home_dir}",
              'shell'      => "#{use_shell}",
              'create_usr' => create_user
            }
          end

        elsif pool_size > 0

          (0...pool_size).each do | idx |
            nameStr = Gridutils.format_username(name_pattern, user_prefix, idx + name_offset)
            commentStr = Gridutils.format_comment(comment_pattern, nameStr, 
                                                  udata[Gridutils::USERS_FIRSTID_T] + idx)
            result[nameStr] = { 
              'uid'        => udata[Gridutils::USERS_FIRSTID_T] + idx,
              'groups'     => grp_list,
              'comment'    => "#{commentStr}",
              'homedir'    => "#{home_dir}",
              'shell'      => "#{use_shell}",
              'create_usr' => create_user
            }

          end

        else
          # static account
          commentStr = Gridutils.format_comment(comment_pattern, user_prefix,
                                                udata[Gridutils::USERS_FIRSTID_T])
          result["#{user_prefix}"] = { 
            'uid'        => udata[Gridutils::USERS_FIRSTID_T],
            'groups'     => grp_list,
            'comment'    => "#{commentStr}",
            'homedir'    => "#{home_dir}",
            'shell'      => "#{use_shell}",
            'create_usr' => create_user
          }
        end
      end
    end

    return result

  end
end


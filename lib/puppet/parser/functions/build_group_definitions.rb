require 'gridutils'

module Puppet::Parser::Functions
  newfunction(:build_group_definitions, :type => :rvalue, :doc => "This function converts group table structure") do | args |
    voenv = args[0]
    
    result = Hash.new
    gid_table = Hash.new

    voenv.each do | voname, vodata |
      vodata[Gridutils::GROUPS_T].each do | group, gdata |

        grpid = gdata[Gridutils::GROUPS_GID_T]
        if gid_table.has_key?(grpid)
          raise "Duplicate gid #{grpid}"
        else
          gid_table[grpid] = gdata[Gridutils::GROUPS_FQAN_T]
        end

        result[group] = {
          'ensure'   => "present",
          'tag'      => [ 'creamce::poolgroup' ],
          'gid'      => grpid
        }

      end
    end
    return result
  end
end


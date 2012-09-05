# Description:
#   Chuck Norris awesomeness
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot chuck norris -- random Chuck Norris awesomeness
#   hubot chuck norris me <user> -- let's see how <user> would do as Chuck Norris
#
# Author:
#   dlinsin

module.exports = (robot) ->
  robot.respond /(chuck norris)( me )?(.*)/i, (msg)->
    user = msg.match[3]
    if user.length == 0
      msg.send "Chuck Norris is an homophobic asshole"
    else
      msg.send "Hey #{user}, Chuck Norris is an homophobic asshole"
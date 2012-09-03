# Description:
#   Checks if tikka is upp
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot tikka status - Checks if <domain> is up
#
# Author:
#   jmhobbs

module.exports = (robot) ->
        robot.respond /tikka status/i, (msg) ->
                msg.http('https://p-1.livemarketdata.com/status/itch/json').get() (err, res, body) ->
                        if err
                                msg.send "ERROR: Unable to connect to the server"
                        data = JSON.parse(body)
                        msg.send "ITCH status is #{data.itch_status} and TCP status is #{data.tcp_status}"
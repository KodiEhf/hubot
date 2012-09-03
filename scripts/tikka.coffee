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
                msg.http('https://p-1.livemarketdata.com/status/itch/json')
                .get() (err, res, body) ->
                        data = JSON.parse(body)
                        if data.itch_status == "online" && data.tcp_status == "online":
                                msg.send "ITCH is up and running"
                        else if data.itch_status != "online":
                                msg.send "ITCH has status #{data.itch_status} with TCP status #{data.tcp_status}"
                        else if data.tcp_status != "online":
                                msg.send "ITCH has status #{data.itch_status} with TCP status #{data.tcp_status}"
                        else:
                                msg.send "ITCH status is unknown"

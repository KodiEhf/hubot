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
#   hubot tippa status - Checks if tippa is up
#
# Author:
#   jmhobbs

module.exports = (robot) ->
        robot.respond /tippa status/i, (msg) ->
                msg.http('https://p-1.livemarketdata.com/status/tip/json').get() (err, res, body) ->
                        if err
                                msg.send "ERROR: Unable to connect to the server"
                        data = JSON.parse(body)
                        msg.send "TIP status is #{data.tip_state} and TCP status is #{data.tip_connection_status}"
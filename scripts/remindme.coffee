# Description:
#   Remind me!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   remind int sec Comment
#   remind int min Comment
#   remind int hr Comment
#   remind time Comment
#
# Author:
#   omarkj

uuid = require 'node-uuid'
require 'date-utils'

module.exports = (robot) ->
  robot.enter (user_connected) ->
    if 'reminders' in user_connected.message.user
      for reminder in user_connected.message.user.reminders
        schedule user_connected, reminder.uuid, reminder.comment, reminder.time
  robot.respond /remind (\S+) sec (.*)/i, (msg) ->
    schedule msg, uuid.v1(), msg.match[2], msg.match[1]*1000
  robot.respond /remind (\S+) min (.*)/i, (msg) ->
    schedule msg, uuid.v1(), msg.match[2],msg.match[1]*60*1000
  robot.respond /remind (\S+) hr (.*)/i, (msg) ->
    schedule msg, uuid.v1(), msg.match[2], msg.match[1]*60*60*1000
  robot.respond /remind (\d{2}):(\d{2}) (.*)/i, (msg) ->
    now = new Date()
    later = new Date()
    later.clearTime()
    later.add
        hours: msg.match[1]
        minutes: msg.match[2]
    compare = Date.compare(now, later)
    if compare == -1
      schedule msg, uuid.v1(), msg.match[3], now.getSecondsBetween(later)*1000
    else
      later.addDays(1)
      schedule msg, uuid.v1(), msg.match[3], now.getSecondsBetween(later)*1000

schedule = (msg, reminder_id, comment, time) ->
  if time <= 0
    msg.send "Smartypants.."
  else if isNaN time
    msg.send "Not a number.."
  else
    reminder_id = 
    now = new Date()
    now.addMilliseconds(time)
    remind_at = now.getTime()
    if !('reminders' in msg.message.user)
      msg.message.user.reminders = []
    msg.message.user.reminders.push
      uuid: reminder_id
      comment: comment
      time: remind_at
    msg.send reminder_id
    msg.send "I'll remind you in #{time/1000} sec"
    callback = ->
      msg.send "Reminder: #{comment}"
    setTimeout callback, time
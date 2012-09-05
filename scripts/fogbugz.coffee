# Description:
#   FogBugz hubot helper
#
# Dependencies:
#   "xml2js": "0.1.14"
#
# Configuration:
#   HUBOT_FOGBUGZ_HOST
#   HUBOT_FOGBUGZ_TOKEN
#
# Commands:
#   bug <number> - provide helpful information about a FogBugz case
#   case <number> - provide helpful information about a FogBugz case
#   start <number> - starts working on this case
#   stop <number> - stops working on this case
#   resolve <number> <comment> - resolves this case
#   close <number> <comment> - closes this case
#   filters - shows your filters
#   filters help - filter help
#   filter use <id> - Select a filter
#   show filter - show what's in your filter
#   fb login username password - Login to fogbugz hubot, should only do it once (unless the brain is restarted)
#
# Notes:
#   
#   curl 'https://HUBOT_FOGBUGZ_HOST/api.asp' -F'cmd=logon' # -F'email=EMAIL' -F'password=PASSWORD'
#   and copy the data inside the CDATA[...] block.
#
#   Tokens only expire if you explicitly log them out, so you should be able to
#   use this token forever without problems.
#
# Author:
#   dstrelau

Parser = require('xml2js').Parser
env = process.env
util = require 'util'

module.exports = (robot) ->
  if env.HUBOT_FOGBUGZ_HOST
    robot.hear /fb login (\S+) (\S+)/, (msg) ->
      msg.http("https://#{env.HUBOT_FOGBUGZ_HOST}/api.asp")
        .query
          cmd: "logon"
          email: msg.match[1]
          password: msg.match[2]
        .post() (err, res, body) ->
          (new Parser()).parseString body, (err,json) ->
            truncate = (text,length=60,suffix="...") ->
              if text.length > length then (text.substr(0,length-suffix.length) + suffix) else text
            if json.error
              handle_error(json.error, msg)
            else
              set_fb_token(robot, msg.message.user.id, json.token)
              msg.send "Awesome, you're now logged on!"
    robot.hear /show filter/, (msg) ->
      token = fetch_fb_token(robot, msg.message.user.id)
      if token is null
        msg.send "Hold on! You don't have a token specified. Set it with\nfb login <username> <password>"
      else
        msg.http("https://#{env.HUBOT_FOGBUGZ_HOST}/api.asp")
          .query
            cmd: "search"
            sFilter: msg.match[1]
            token: token
            cols: "ixBug,sTitle,sStatus,sProject,sArea,ixPriority,sPriority,sLatestTextSummary"
          .post() (err, res, body) ->
            (new Parser()).parseString body, (err,json) ->
              truncate = (text,length=60,suffix="...") ->
                if text.length > length then (text.substr(0,length-suffix.length) + suffix) else text
              if json.error
                handle_error(json.error, msg)
              else
                cases = json.cases['@'].count
                if cases == '0'
                  msg.send "No match your filter."
                else
                  msg.send "#{cases} match your filter, they are:"
                tot_details = []
                for bug in json.cases.case
                  if typeof bug.sLatestTextSummary == 'object'
                    bug.sLatestTextSummary = "N/A"
                  detail = [
                    "FogBugz #{bug.ixBug}: #{bug.sTitle}"
                    "  Priority: #{bug.ixPriority} - #{bug.sPriority}"
                    "  Project: #{bug.sProject} (#{bug.sArea})"
                    "  Latest Comment: #{bug.sLatestTextSummary}"
                    "  Link: https://#{env.HUBOT_FOGBUGZ_HOST}/?#{bug.ixBug}\n"]
                  tot_details.push detail.join("\n")
                msg.send tot_details.join("\n")
    robot.hear /filters help/, (msg) ->
      token = fetch_fb_token(robot, msg.message.user.id)
      if token is null
        msg.send "Hold on! You don't have a token specified. Set it with\nfb login <username> <password>"
      else
        msg.send "Yeah, filters are a bit tricky.\n
To get a list of all available filters type: filters\n
You can then set a new filter by typing\nfilter use <id_of_filter>\n
To show the cases in your filter then type show filter\n
You do not need to set a filter every time, it's saved!\n
You can configure your filters here: https://kodi.fogbugz.com/default.asp?pg=pgManageFilters"
    robot.hear /filter use (.*)/, (msg) ->
      token = fetch_fb_token(robot, msg.message.user.id)
      if token is null
        msg.send "Hold on! You don't have a token specified. Set it with\nfb login <username> <password>"
      else
        msg.http("https://#{env.HUBOT_FOGBUGZ_HOST}/api.asp")
          .query
            cmd: "setCurrentFilter"
            sFilter: msg.match[1]
            token: token
          .post() (err, res, body) ->
            (new Parser()).parseString body, (err,json) ->
              truncate = (text,length=60,suffix="...") ->
                if text.length > length then (text.substr(0,length-suffix.length) + suffix) else text
              if json.error
                handle_error(json.error, msg)
              else
                msg.send "Filter set kthxbye"
    robot.hear /filters$/, (msg) ->
      token = fetch_fb_token(robot, msg.message.user.id)
      if token is null
        msg.send "Hold on! You don't have a token specified. Set it with\nfb login <username> <password>"
      else
        msg.http("https://#{env.HUBOT_FOGBUGZ_HOST}/api.asp")
          .query
            cmd: "listFilters"
            token: token
          .post() (err, res, body) ->
            (new Parser()).parseString body, (err,json) ->
              truncate = (text,length=60,suffix="...") ->
                if text.length > length then (text.substr(0,length-suffix.length) + suffix) else text
              if json.error
                handle_error(json.error, msg)
              else
                res = ""
                for filter in json.filters.filter
                  res = "#{res}Filter name: #{filter['#']}, Id: #{filter['@'].sFilter}\n"
                msg.send res
    robot.hear /resolve (\d+) (.*)/, (msg) ->
      token = fetch_fb_token(robot, msg.message.user.id)
      if token is null
        msg.send "Hold on! You don't have a token specified. Set it with\nfb login <username> <password>"
      else
        msg.http("https://#{env.HUBOT_FOGBUGZ_HOST}/api.asp")
          .query
            cmd: "resolve"
            token: token
            ixBug: msg.match[1]
            sEvent: msg.match[2]
          .post() (err, res, body) ->
            (new Parser()).parseString body, (err,json) ->
              truncate = (text,length=60,suffix="...") ->
                if text.length > length then (text.substr(0,length-suffix.length) + suffix) else text
              if json.error
                handle_error(json.error, msg)
              else
                msg.send "Busy day! I've marked case #{msg.match[1]} resolved with the comment #{msg.match[2]}."
    robot.hear /close (\d+) (.*)/, (msg) ->
      token = fetch_fb_token(robot, msg.message.user.id)
      if token is null
        msg.send "Hold on! You don't have a token specified. Set it with\nfb login <username> <password>"
      else
        msg.http("https://#{env.HUBOT_FOGBUGZ_HOST}/api.asp")
          .query
            cmd: "close"
            token: token
            ixBug: msg.match[1]
            sEvent: msg.match[2]
          .post() (err, res, body) ->
            (new Parser()).parseString body, (err,json) ->
              truncate = (text,length=60,suffix="...") ->
                if text.length > length then (text.substr(0,length-suffix.length) + suffix) else text
              if json.error
                handle_error(json.error, msg)
              else
                msg.send "Busy day! I've marked case #{msg.match[1]} closed with the comment #{msg.match[2]}."
    robot.hear /start (\d+)/, (msg) ->
      token = fetch_fb_token(robot, msg.message.user.id)
      if token is null
        msg.send "Hold on! You don't have a token specified. Set it with\nfb login <username> <password>"
      else
        msg.http("https://#{env.HUBOT_FOGBUGZ_HOST}/api.asp")
          .query
            cmd: "startWork"
            token: token
            ixBug: msg.match[1]
          .post() (err, res, body) ->
            (new Parser()).parseString body, (err,json) ->
              truncate = (text,length=60,suffix="...") ->
                if text.length > length then (text.substr(0,length-suffix.length) + suffix) else text
              if json.error
                handle_error(json.error, msg)
              else
                msg.send "I've marked you working on case #{msg.match[1]}. Remember to mark it as stopped when you are done! Good luck."
    robot.hear /stop/, (msg) ->
      token = fetch_fb_token(robot, msg.message.user.id)
      if token is null
        msg.send "Hold on! You don't have a token specified. Set it with\nfb login <username> <password>"
      else
        msg.http("https://#{env.HUBOT_FOGBUGZ_HOST}/api.asp")
          .query
            cmd: "stopWork"
            token: token
          .post() (err, res, body) ->
            (new Parser()).parseString body, (err,json) ->
              truncate = (text,length=60,suffix="...") ->
                if text.length > length then (text.substr(0,length-suffix.length) + suffix) else text
              if json.error
                handle_error(json.error, msg)
              else
                msg.send "I've marked you not working on any case. Good job! You deserve a beer."
    robot.hear /estimate (\d+) (\d+)/, (msg) ->
      token = fetch_fb_token(robot, msg.message.user.id)
      if token is null
        msg.send "Hold on! You don't have a token specified. Set it with\nfb login <username> <password>"
      else        
        msg.http("https://#{env.HUBOT_FOGBUGZ_HOST}/api.asp")
          .query
            cmd: "edit"
            token: token
            ixBug: msg.match[1]
            hrsCurrEst: msg.match[2]
          .post() (err, res, body) ->
            (new Parser()).parseString body, (err,json) ->
              truncate = (text,length=60,suffix="...") ->
                if text.length > length then (text.substr(0,length-suffix.length) + suffix) else text
              if json.error
                handle_error(json.error, msg)
              else
                msg.send "Awesome. Case #{msg.match[1]} should now have #{msg.match[2]} hours estimated."
    robot.hear /(?:(?:fog)?bugz?|case) (\d+)/, (msg) ->
      token = fetch_fb_token(robot, msg.message.user.id)
      if token is null
        msg.send "Hold on! You don't have a token specified. Set it with\nfb login <username> <password>"
      else        
        msg.http("https://#{env.HUBOT_FOGBUGZ_HOST}/api.asp")
          .query
            cmd: "search"
            token: token
            q: msg.match[1]
            cols: "ixBug,sTitle,sStatus,sProject,sArea,sPersonAssignedTo,ixPriority,sPriority,sLatestTextSummary"
          .post() (err, res, body) ->
            (new Parser()).parseString body, (err,json) ->
              truncate = (text,length=60,suffix="...") ->
                if text.length > length then (text.substr(0,length-suffix.length) + suffix) else text
              bug = json.cases?.case
              if bug
                msg.send "https://#{env.HUBOT_FOGBUGZ_HOST}/?#{bug.ixBug}"
                details = [
                  "FogBugz #{bug.ixBug}: #{bug.sTitle}"
                  "  Priority: #{bug.ixPriority} - #{bug.sPriority}"
                  "  Project: #{bug.sProject} (#{bug.sArea})"
                  "  Status: #{bug.sStatus}"
                  "  Assigned To: #{bug.sPersonAssignedTo}"
                  "  Latest Comment: #{truncate bug.sLatestTextSummary}"
                ]
                msg.send details.join("\n")

fetch_fb_token = (robot, username) ->
  robot.brain.data.users[username]['fb_token']

set_fb_token = (robot, username, token) ->
  robot.brain.data.users[username].fb_token = token
  robot.brain.save()

handle_error = (error, msg) ->
  code = error['@'].code
  if code is '7'
    msg.send "Case has no estimate, make an estimate like this:\nestimate <caseno> <hours>"
  else if code is '5'
    msg.send "This case doesn't exist."
  else if code is '27'
    msg.send "Bug in hubot! This API method doesn't exist!"
  else if code is '1'
    msg.send "Whoopsie. Wrong username or password"
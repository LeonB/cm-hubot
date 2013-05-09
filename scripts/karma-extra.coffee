# Description:
#   Additons for tracking arbitrary karma
#
# Dependencies:
#   karma.coffee
#
# Configuration:
#   None
#
# Commands:
#   hubot karma best N - show the top N
#   hubot karma top N - show the top N
#   hubot karma worst N - show the bottom N
#   hubot karma bottom N - show the bottom N
#
# Author:
#   Steven Jones

class Karma

  constructor: (@robot) ->

  sort: ->
    s = []
    for key, val of @robot.brain.data.karma
      s.push({ name: key, karma: val })
    s.sort (a, b) -> b.karma - a.karma

  top: (n = 5) ->
    sorted = @sort()
    sorted.slice(0, n)

  bottom: (n = 5) ->
    sorted = @sort()
    sorted.slice(-n).reverse()

module.exports = (robot) ->
  karma = new Karma robot

  robot.respond /karma (best|top) (\d+)$/i, (msg) ->
    verbiage = ["The Best " + msg.match[2]]
    for item, rank in karma.top(msg.match[2])
      verbiage.push "#{rank + 1}. #{item.name} - #{item.karma}"
    msg.send verbiage.join("\n")

  robot.respond /karma (worst|bottom) (\d+)$/i, (msg) ->
    verbiage = ["The Worst " + msg.match[2]]
    for item, rank in karma.bottom(msg.match[2])
      verbiage.push "#{rank + 1}. #{item.name} - #{item.karma}"
    msg.send verbiage.join("\n")
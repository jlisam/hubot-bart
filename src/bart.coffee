# Description:
#   Hubot knows BART train departure times
#
# Dependencies:
#   "xml2js": "*"
#   "javascript-natural-sort": "*"
#
# Configuration:
#   Define an origin station abbreviation. (MONT = Montgomery St)
#
# Commands:
#   hubot bart - next six BART train departures
#
# Author:
#   Peter Tripp

xml2js = require 'xml2js'
naturalSort = require 'javascript-natural-sort'

# Station abbreviation list: http://api.bart.gov/docs/etd/etd.aspx
station = process.env.HUBOT_BART_STATION
apikey = 'MW9S-E7SL-26DU-VV8V'
url = "http://api.bart.gov/api/etd.aspx?cmd=etd&orig=#{station}&key=#{apikey}"

module.exports = (robot) ->
  robot.respond /bart/i, (msg) ->
    msg.http(url)
    .get() (err, res, body) ->
      if res.statusCode is 200 and !err
        parser = new xml2js.Parser()
        parser.parseString body, (err, result) ->
          trains = { South:[], North:[] }
          if not result.root.message[0]
            msg.send "BART trains departing soon from " + result.root.station[0].name + ':'
            for dest in result.root.station[0].etd
              for est in dest.estimate
                if (Math.floor(est.minutes) > 0)
                  line = dest.destination.toString().split('/')[0]
                  trains[est.direction[0]].push(' ' + est.minutes + 'm ' + line)
            for direction,estimates of trains
              estimates.sort(naturalSort)
              text = if (estimates.length) then estimates[0..5].toString() else 'None'
              msg.send direction + "bound: " + text
          else
            msg.send "No BART trains departing soon from " + result.root.station[0].name

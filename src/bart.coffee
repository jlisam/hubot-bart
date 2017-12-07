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


xml2js = require 'xml2js'
naturalSort = require 'javascript-natural-sort'

# Station abbreviation list: http://api.bart.gov/docs/etd/etd.aspx

stations = {}
stations["12th"] =  "12th St. Oakland City Center"
stations["16th"] =  "16th St. Mission (SF)"
stations["19th"] =  "19th St. Oakland"
stations["24th"] =  "24th St. Mission (SF)"
stations["ashb"] =  "Ashby (Berkeley)"
stations["balb"] =  "Balboa Park (SF)"
stations["bayf"] =  "Bay Fair (San Leandro)"
stations["cast"] =  "Castro Valley"
stations["civc"] =  "Civic Center (SF)"
stations["cols"] =  "Coliseum"
stations["colm"] =  "Colma"
stations["conc"] =  "Concord"
stations["daly"] =  "Daly City"
stations["dbrk"] =  "Downtown Berkeley"
stations["dubl"] =  "Dublin/Pleasanton"
stations["deln"] =  "El Cerrito del Norte"
stations["plza"] =  "El Cerrito Plaza"
stations["embr"] =  "Embarcadero (SF)"
stations["frmt"] =  "Fremont"
stations["ftvl"] =  "Fruitvale (Oakland)"
stations["glen"] =  "Glen Park (SF)"
stations["hayw"] =  "Hayward"
stations["lafy"] =  "Lafayette"
stations["lake"] =  "Lake Merritt (Oakland)"
stations["mcar"] =  "MacArthur (Oakland)"
stations["mlbr"] =  "Millbrae"
stations["mont"] =  "Montgomery St. (SF)"
stations["nbrk"] =  "North Berkeley"
stations["ncon"] =  "North Concord/Martinez"
stations["oakl"] =  "Oakland Int'l Airport"
stations["orin"] =  "Orinda"
stations["pitt"] =  "Pittsburg/Bay Point"
stations["phil"] =  "Pleasant Hill"
stations["powl"] =  "Powell St. (SF)"
stations["rich"] =  "Richmond"
stations["rock"] =  "Rockridge (Oakland)"
stations["sbrn"] =  "San Bruno"
stations["sfia"] =  "San Francisco Int'l Airport"
stations["sanl"] =  "San Leandro"
stations["shay"] =  "South Hayward"
stations["ssan"] =  "South San Francisco"
stations["ucty"] =  "Union City"
stations["warm"] =  "Warm Springs/South Fremont"
stations["wcrk"] =  "Walnut Creek"
stations["wdub"] =  "West Dublin"
stations["woak"] =  "West Oakland"

module.exports = (robot) ->
  robot.respond /bart from (.+)/i , (msg) ->
    station = (msg.match[1] || 'MONT').toLowerCase()
    apikey = process.env.BART_API_KEY
    if !apikey
      return msg.send "No apikey supplied"
    console.log  
    if !stations[station]
      return msg.send "Station #{station} is not in the list, execute the `list` command to find station names" 
    url = "http://api.bart.gov/api/etd.aspx?cmd=etd&orig=#{station}&key=#{apikey}"    
    msg.http(url)
    .get() (err, res, body) ->
      if res.statusCode is 200 and !err
        parser = new xml2js.Parser()
        parser.parseString body, (err, result) ->
          trains = { South:[], North:[] }
          if not result.root.message[0]
            for dest in result.root.station[0].etd
              for est in dest.estimate
                if (Math.floor(est.minutes) > 0)
                  line = dest.destination.toString().split('/')[0]
                  trains[est.direction[0]].push(' ' + est.minutes + 'm ' + line)
            for direction,estimates of trains
              estimates.sort(naturalSort)
              text = if (estimates.length) then estimates[0..5].toString() else 'None'
              msg.send "BART trains departing soon from " + result.root.station[0].name + ':' + '\n' + direction + "bound: " + text
          else
            msg.send "No BART trains departing soon from " + result.root.station[0].name
  
  robot.respond /bart list/i , (msg) ->
    return msg.send JSON.stringify(stations, null, 2)



## hubot-bart [![NPM version](https://badge.fury.io/js/hubot-bart.png)](http://badge.fury.io/js/hubot-bart)

A [Hubot](https://github.com/github/hubot) plugin to tell you what [BART](http://www.bart.gov/) trains are coming soon.

### Usage

    hubot bart - next six BART train departures

### Installation
1. cd into your hubot directory and run `npm install --save hubot-bart` to add it to your package.json as a dependency.
2. Add `"hubot-bart"` to your `external-scripts.json` file.
3. Set HUBOT_BART_STATION to specify an origin station
4. Restart Hubot.

### Configuration
* HUBOT_BART_STATION - set this to the station code, i.e. CIVC, MONT, 19TH etc. Full list is [here](http://api.bart.gov/docs/overview/abbrev.aspx) but make sure to use uppercase.

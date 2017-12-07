Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/bart.coffee')

describe 'example script', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'will respond with apikey not found', ->
    @room.user.say('alice', '@hubot bart from BALB').then =>
      expect(@room.messages).to.eql [
      	['alice', '@hubot bart from BALB']
      	['hubot', 'No apikey supplied']
      ]
  it 'will respond with a list of stations', ->
    process.env['BART_API_KEY'] = "123"   
    @room.user.say('alice', '@hubot bart from xyz').then =>

      expect(@room.messages).to.eql [
        ['alice', '@hubot bart from xyz']
        ['hubot', "Station xyz is not in the list, execute the `list` command to find station names"]
      ]

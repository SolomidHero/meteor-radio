{ Meteor } = require 'meteor/meteor'
{ Mongo } = require 'meteor/mongo'
fs = require 'fs'

global.Tracks = new Mongo.Collection 'tracks'

global.addTrack = (options) ->
  unless options
    throw new Error 'options required'
  lastTrack = Tracks.findOne({},{sort:{id:-1}})
  currentId = if lastTrack then lastTrack.id else 0
  options.id = currentId + 1
  Tracks.insert options
  return options.id

Meteor.startup ->

  unless Tracks.find().count() > 0
    files = fs.readdirSync '/Users/max2/projects/sandbox/meteor-radio/public/tracks'
    files.forEach (file) ->
      if file[0] == '.' or file.indexOf('.mp3') < 0
        return
      addTrack
        artist: file.split(' - ')[0]
        title: file
        url: '/tracks/' + file
    # for i in [0..10]
    #   addTrack
    #     artist: 'TATARKA ' + Math.floor(Math.random()*1000000*1000000).toString(32)
    #     title: 'АЛТЫН ' + Math.floor(Math.random()*1000000*1000000).toString(32)
    #     url: '/tracks/track' + Math.floor(Math.random()*7) + '.mp3'
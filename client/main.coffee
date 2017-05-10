{ Template } = require 'meteor/templating'
{ Meteor } = require 'meteor/meteor'
{ Mongo } = require 'meteor/mongo'
{ ReactiveVar } = require 'meteor/reactive-var'

reactiveTitle = new ReactiveVar 'Awesome Radio'

reactiveId = new ReactiveVar 1

reactiveCurrentTime = new ReactiveVar 0
reactiveDuration = new ReactiveVar 0
reactivePaused = new ReactiveVar false

updateSlider = new ReactiveVar true

import './main.html'

global.Tracks = new Mongo.Collection 'tracks'

# trackId = _.shuffle(Tracks.find({}, { fields: { _id: true }}).fetch())[0]._id
# console.log trackId
# Tracks.find(trackId)

setRandomTrackId = ->
  tracksCount = Tracks.find().count()
  reactiveId.set Math.floor(Math.random()*tracksCount + 1)

seekTo = (time) ->
  elem = document.querySelector '#audioElem'
  elem.currentTime = time

updatePaused = ->
  elem = document.querySelector '#audioElem'
  unless elem
    return false
  reactivePaused.set elem.paused

initListeners = ->
  elem = document.querySelector '#audioElem'
  elem.addEventListener 'ended', ->
    console.log 123
    do setRandomTrackId

  elem.addEventListener 'canplay', ->
    reactiveDuration.set elem.duration

  elem.addEventListener 'timeupdate', ->
    reactiveCurrentTime.set elem.currentTime

  elem.addEventListener 'play', -> 
    do updatePaused
  elem.addEventListener 'pause', -> 
    do updatePaused
  elem.addEventListener 'ended', -> 
    do updatePaused

Template.title.onRendered ->
  do setRandomTrackId
  do initListeners

Template.title.helpers
  title: ->
    reactiveTitle.get()

Template.player.events
  'click #nextBtn': ->
    do setRandomTrackId

  'click #playPauseBtn': ->
    elem = document.querySelector('#audioElem')
    if elem.paused
      elem.play()
    else
      elem.pause()

  'mousedown #slider': ->
    updateSlider.set false

  'mouseup #slider': ->
    seekTo $('#slider').val()
    updateSlider.set true




Template.player.helpers
  track: ->
    
    randomTrack = Tracks.find
      id: reactiveId.get()
    .fetch()[0]

    randomTrack.title = randomTrack.title.replace(".mp3", "")
    randomTrack.artist = randomTrack.title.replace(".mp3", "")

    randomTrack

  duration: ->
    reactiveDuration.get()

  currentTime: ->
    if updateSlider.get()
      reactiveCurrentTime.get()
    else
      $('#slider').val()

  isPaused: -> 
    do reactivePaused.get




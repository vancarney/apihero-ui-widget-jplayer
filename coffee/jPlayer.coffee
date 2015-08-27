###
  Player.coffee
  jPlayer Controller
###
ApiHeroUI.widgets ?= {}
class ApiHeroUI.widgets.jPlayer extends ApiHeroUI.core.View
  _player: null
  _ready: false
  _duration:0
  seek:(v)->
    if v? then @_player.jPlayer "playHead", v else @_player.jPlayer "playHead"
  isReady:()->
    @_ready
  load:(url)->
    o =  if ApiHeroUI.widgets.jPlayer.utils.isSafari() then {mp3:url} else {rtmpa:url}
    console.log o
    @_player.jPlayer "setMedia", o
    @play() if @autoplay
  autoplay:true
  volume:(v)->
    if v? then @_player.jPlayer "volume", v else @_player.jPlayer "volume"
  play:(time)->
    @_player.jPlayer "play", time 
  pause:()->
    @_player.jPlayer "pause"
  init:(o={})->
    optMethods =
      ready: ()=>
        @_ready = true
        @trigger "ready"
        @play() if @autoplay
      play:()=>
        @trigger "play"
      loadstart: (evt)=>
        @_duration = evt.jPlayer.status.duration
        console.log 'loadstart'
        @trigger "loadStart", evt
      progress: (evt)=>
        @trigger "progress", evt
      timeupdate: (evt)=>
        if evt.jPlayer.status.duration != @_duration
          @trigger "durationChange", (@_duration = evt.jPlayer.status.duration)
        @trigger "timeUpdate", (
         timestamp: $.jPlayer.convertTime evt.jPlayer.status.currentTime
         currentTime: evt.jPlayer.status.currentTime
         percent: (evt.jPlayer.status.currentTime/@_duration)*100
        )
      loadedmetadata: (evt)=>
        if evt.jPlayer.status.duration > 0 && evt.jPlayer.status.duration != @_duration
          @trigger "durationChange", (@_duration = evt.jPlayer.status.duration)
      ended: (evt)=>
        @trigger "trackEnded"
    opts = _.clone @defaults
    _.extend opts, optMethods, o.options || {}
    @_player = @$el.jPlayer opts
    @queue = new ApiHeroUI.widgets.jPlayer.QueueClass
class ApiHeroUI.widgets.jPlayer.QueueClass extends Backbone.Collection
  model:Backbone.Model.extend
    defaults:
      file:null
      type:"rtmpv"
ApiHeroUI.widgets.jPlayer.utils =
  isSafari:->
    (/Safari/.test navigator.userAgent and /Apple Computer/.test navigator.vendor)
console.log ApiHeroUI.widgets.jPlayer.utils
ApiHeroUI.widgets.jPlayer.controls = {}
ApiHeroUI.widgets.jPlayer.components = {}
ApiHeroUI.widgets.jPlayer::defaults = 
  swfPath:"/"
  supplied: "#{if ApiHeroUI.widgets.jPlayer.utils.isSafari() then 'mp3' else 'rtmpa'}"
  solution: 'html, flash'
  preload: "metadata"
  wmode:"window"
  errorAlerts: true
  warningAlerts: true
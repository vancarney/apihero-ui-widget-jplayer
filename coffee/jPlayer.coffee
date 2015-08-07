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
    o =  if global.isSafari() then {mp3:url} else {rtmpv:url}
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
    opts = _.clone @defaults
    _.extend opts, o.options || {}
    @_player = @$el.jPlayer opts
    @queue = new ApiHeroUI.widgets.jPlayer.QueueClass
class ApiHeroUI.widgets.jPlayer.QueueClass extends Backbone.Collection
  model:Backbone.Model.extend
    defaults:
      file:null
      type:"mp3"
ApiHeroUI.widgets.jPlayer::defaults = 
  swfPath:"/"
  supplied: "#{if global.isSafari() then 'mp3' else 'rtmpv'}"
  preload: "metadata"
  ready: ()=>
    @_ready = true
    @trigger "ready"
    @play() if @autoplay
  play:()=>
    @trigger "play"
  loadstart: (evt)=>
    @_duration = evt.jPlayer.status.duration
    @trigger "loadStart", evt
  progress: (evt)=>
    @trigger "progress", evt
  timeupdate: (evt)=>
    if evt.jPlayer.status.duration != @_duration
      @trigger "durationChange", (@_duration = evt.jPlayer.status.duration)
    @trigger "timeUpdate", (
     timestamp:$.jPlayer.convertTime evt.jPlayer.status.currentTime
     currentTime:evt.jPlayer.status.currentTime
     percent:(evt.jPlayer.status.currentTime/@_duration)*100
    )
  loadedmetadata: (evt)=>
    if evt.jPlayer.status.duration > 0 && evt.jPlayer.status.duration != @_duration
      @trigger "durationChange", (@_duration = evt.jPlayer.status.duration)
  ended: (evt)=>
    @trigger "trackEnded"
ApiHeroUI.widgets.jPlayer.controls = {}
ApiHeroUI.widgets.jPlayer.components = {}
###
  Player.coffee
  jPlayer Controller
###
global = exports ? window
global.Backbone.Player extends Backbone.View
  el: "#player"
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
  init:(o)->
    @_player = @$el.jPlayer
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
          
###
 Play/Pause UI sub-view
###
global.Backbone.PlayPause extends Backbone.View
  events:
    "click": "toggle"
  playstate: (state)->
    @$el.attr "class", state if /^(play+||pause+)\-state?/.exec state
  toggle:()->
    @$el.attr "class", if @$el.attr("class") == "play-state" then "pause-state" else "play-state"
    @trigger @$el.attr "class"
    @$el.blur()
    false
  initialize:(o)->
    @$el.addClass 'pause-state' unless @$el.hasClass 'pause-state'
        
###
 Scrubber UI sub-view
### 
# global.Tunstr.Scrubber = Backbone.View.extend
  # el: "#scrubber"
  # _duration:0
  # duration:(v)->
    # @_duration = v if v?
    # @_duration
  # update:(v)->
    # console.log "bar: #{@$el.find('.bar').length}"
    # @$el.find(".bar").css "width", "#{(v/@_duration)*100}%"
  # initialize:(o)->
    # @$el.find("span").each (i,el)=>
      # @$el.disableTextSelect()
    # @$el.bind "mousedown", (evt)=>
      # @$el.bind "mousemove", (evt)=>
        # @$el.find(".bar").css( "width", "#{(evt.offsetX/@$el.width())*100}%").children().each (i,el)->
          # @$el.blur()
    # @$el.bind "mouseup", (evt)=>
      # @trigger "seek", (evt.offsetX/@$el.width())*@_duration
      # @$el.unbind( "mousemove" ).children().each (i,el)->
          # @$el.blur() if @$el.blur     
###
 Stats sub-view
###
global.Backbone.PlayerStats extends Backbone.View
  subviews:
    "#trackTitle": Backbone.View.extend
      render:(v)->
        @$el.text v if v?
        @$el.text
    "#trackTime": Backbone.View.extend
      render:(v)->
        @$el.text v if v?
        @$el.text
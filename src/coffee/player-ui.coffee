class global.PlayerUI extends Backbone.CompositeView
  _index:-1
  play:()->
    global.app.player.play()
  pause:()->
    global.app.player.pause()
  setTrack:(idx)->
    @hud.setModel (m = @model.at (@_index = idx))
    # console.log "set track:"
    # console.log m
    # global.app.player.load m.get "mp3_file_path"
  fadv:->
    # if (@play_mode == "discovery")
      # return @discovery.discover()
    # if ((idx = @_index + 1) < @model.length) && (m = @model.at(@_index = idx))?
      # @player.load m.get "mp3_file_path"
      # @hud.setModel @model.at @_index
  frev:->
    # if ((idx = _index - 1) >= 0) && (m = @model.at(@_index = idx))?
      # global.app.player.load  m.get "mp3_file_path"
      # @hud.setModel @model.at @_index
  fetch:(url)->   
    $.get url, (d,x,r)=>
      if (m = @model.get d.id)?
        @model.models.splice idx, 1 if (idx = @model.indexOf m)?
        @model.add m,
          at:_index + 1
  # load:(url)->
    # @track = @webAudio.addTrack url
    # @hud = new global.Tunstr.PlayerDisplay
      # el: "#trackHUD"
      # model: @model.at @_index
    # @draw()
  draw:->
    true
    # window.setInterval (=>
    # ),1000 / 60
  setModel:(model)->
    # console.log "model:"
    # console.log model
    # (@model=model).on "add", (m)=>
      # @_index = @model.length - 1
      # @player.load m.get "mp3_file_path"
      # @hud.setModel m
  subviews:
    "#trackHUD": global.PlayerDisplay
    ".ctrl_buttons": global.PlayerControls
  init:(o)->
    if (@model)
      @model.fetch
        success:(c,r)=>
          console.log "loaded"
          # @fadv()
    global.app.player.on "loadStart", (evt)=>
      console.log "loadstart"
      @$el.find(".time").text "00:00"
      @hud.setModel global.app.queue.getCurrentTrack()
    @discovery = new global.Tunstr.Discovery

    

    @[".ctrl_buttons"].on "play", @play, @
    @[".ctrl_buttons"].on "pause", @pause, @
    @[".ctrl_buttons"].on "fadv", =>
      global.app.queue.next()
    @[".ctrl_buttons"].on "frev", =>
      global.app.queue.prev()
    @[".ctrl_buttons"].on "playlist", (tog)=>
      return if !(@hud?)
      if tog then @hud.expand() else @hud.collapse()
    @[".ctrl_buttons"].on "share", =>
      @trigger "share"
    @[".ctrl_buttons"].on "discover", =>
      global.app.queue.discover()
    global.app.player.on( "play", =>
      console.log "play"
      $(".ppause").addClass "selected"
    ).on("timeUpdate", (d)=>
      tArr.shift() if (tArr = d.timestamp.split ':')[0] == '0'
      @$el.find(".time").text tArr.join ':'
    )
    global.app.player.on("trackEnded", (evt)=>
      if global.app.queue._discoveryMode
        global.app.queue.discover()
      else if @play_mode == "playlist"
        @fadv()
      else
        @pause()
    )
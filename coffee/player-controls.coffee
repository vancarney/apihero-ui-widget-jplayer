class ApiHeroUI.Widgets.jPlayer.PlayerControls extends Backbone.View
  events:
    "click .ppause": (evt)=>
      evt.preventDefault()
      el = $(evt.target)
      if (el.hasClass("selected"))
        el.removeClass "selected"
        @trigger "pause"
      else
        el.addClass "selected"
        @trigger "play"
      false
    "click .fadv": (evt)=>
      evt.preventDefault()
      @trigger "fadv"
      false
    "click .frev": (evt)=>
      evt.preventDefault()
      @trigger "frev"
      false
    "click #playlist_tog": (evt)=>
      func = if $(evt.target).hasClass "selected" then "removeClass" else "addClass"
      $(evt.target)[ func ] "selected"
      @trigger "playlist", $(evt.target).hasClass "selected"
    "click #track_share":(evt)=>
      console.log "click"
      @trigger "share"
    "click #discovery":(evt)=>
      @trigger "discover"
    "click #track_dislike":(evt)->
      if global.app.queue._discoveryMode then @trigger "discover" else  @trigger "fadv"
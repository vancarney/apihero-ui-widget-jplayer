class ApiHeroUI.Widgets.jPlayer.PlayerDisplay extend ApiHeroUI.core.View
  subviews:
    "#trackbar":Scrubber
    "#meta": ApiHeroUI.core.View.extend
      childrenComplete:->
        @$('span').rotaterator
          fadeSpeed: 1200
          pauseSpeed: 6000
      init:->
        @model = new Backbone.Model model: @__parent.model.attributes
  expand:()->
    @$el.animate {top: -386}, 700
  collapse:()->
    @$el.animate {top: -50}, 600
  childrenComplete:->
    @__player.on "timeUpdate", (d)=>
      @["#trackbar"].update d.currentTime
    @__player.on "loadStart", (d)=>
      console.log "duration: #{@__playerr._duration}"
      @["#trackbar"].duration @__player._duration
    @__player.on "durationChange", (d)=>
      console.log "duration: #{@__player._duration}"
      @["#trackbar"].duration @__player._duration
  init:(o)->
    if o.hasOwnProperty 'player'
      unless o.player instanceof ApiHeroUI.Widgets.jPlayer
        console.log "Error: player was required to be a subclass of ApiHeroUI.Widgets.jPlayer."
        return delete o.player 
      @__player = o.player

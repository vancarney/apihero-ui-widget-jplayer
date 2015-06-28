class Backbone.PlayerDisplay extend Backbone.CompositeView
  subviews:
    "#trackbar":Scrubber
    "#meta": Backbone.CompositeView.extend
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
  init:->
    @__player = global.app.player
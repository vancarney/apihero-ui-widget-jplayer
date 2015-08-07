class ApiHeroUI.widgets.jPlayer.controls.Scrubber extends Backbone.View
  events:
    "mousedown":(evt)->
      $(window).mouseup (evt)=>
        delete @__isScrubbing
        @$el.unbind 'mousemove'
      @$el.mousemove (evt)=>
        @__isScrubbing = true
        # @trigger "seek", (evt.offsetX/@$el.width())*100
        @$el.blur()
        @$('.bar')
        .css 'width', "#{(evt.offsetX/@$el.width())*100}%"
        .children()
        .blur()
    "mouseup": (evt)=>
      console.log Math.round (evt.offsetX/@$el.width())*100
      delete @__isScrubbing
      @trigger "seek", Math.round (evt.offsetX/@$el.width())*100
      @$el.unbind( "mousemove" ).blur()
  isScrubbing:->
    @hasOwnProperty '__isScrubbing'
  _duration:0
  duration:(v)->
    @_duration = v if v?
    @_duration
  update:(v)->
    return if @isScrubbing()
    @$el.find(".bar").css "width", "#{(v/@_duration)*100}%"
  initialize:(o)->
    @$el.find("span").each (i,el)=>
      $(el).disableTextSelect()
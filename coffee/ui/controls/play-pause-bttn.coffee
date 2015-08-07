###
 Play/Pause UI sub-view
###
class ApiHeroUI.widgets.jPlayer.controls.PlayPause extends Backbone.View
  events:
    "click": "toggle"
  playstate: (state)->
    @$el.attr "class", state if /^(play+||pause+)\-state?/.exec state
  toggle:(evt)->
    evt.preventDefault()
    @$el.attr "class", if @$el.attr("class") == "play-state" then "pause-state" else "play-state"
    @trigger @$el.attr "class"
    @$el.blur()
    false
  initialize:(o)->
    @$el.addClass 'pause-state' unless @$el.hasClass 'pause-state'
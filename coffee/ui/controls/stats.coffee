###
 Stats sub-view
###
class ApiHeroUI.widgets.jPlayer.controls.PlayerStats extends ApiHeroUI.core.View
  subviews:
    "#trackTitle": Backbone.View.extend
      render:(v)->
        @$el.text v if v?
        @$el.text
    "#trackTime": Backbone.View.extend
      render:(v)->
        @$el.text v if v?
        @$el.text
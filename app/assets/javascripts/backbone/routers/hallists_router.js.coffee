class Arto.Routers.HallistsRouter extends Backbone.Router
  initialize: (options) ->
    @hallists = new Arto.Collections.HallistsCollection()
    @hallists.reset options.hallists

  routes:
    "hallists"          : "index"
    "hallists/.*"       : "index"
    "hallists/search"   : "index"
    "hallists/search/:search_term"   : "index"

  index: ->
    window.scrollInfinite.initialize() if window.scrollInfinite.initialized == false
    @view = new Arto.Views.Hallists.IndexView(hallists: @hallists)
    @view.render()
  
class Arto.Routers.CollectionsRouter extends Backbone.Router
  initialize: (options) ->
    @collections = new Arto.Collections.CollectionsCollection()
    @collections.reset options.collections

  routes:
    "collections"                     : "index"
    "collections/.*"                  : "index"
    "collections/search/:search_term" : "index"
    

  index: ->
    window.scrollInfinite.initialize() if window.scrollInfinite.initialized == false
    @view = new Arto.Views.Collections.IndexView(collections: @collections)
    @view.render()

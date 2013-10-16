class Arto.Routers.ArtistsRouter extends Backbone.Router
  initialize: (options) ->
    @artists = new Arto.Collections.ArtistsCollection()
    @artists.reset options.artists

  routes:
    "artists"     : "index"
    "artists/.*"  : "index"


  index: ->
    window.scrollInfinite.initialize() if window.scrollInfinite.initialized == false
    @view = new Arto.Views.Artists.IndexView(artists: @artists)
    @view.render()
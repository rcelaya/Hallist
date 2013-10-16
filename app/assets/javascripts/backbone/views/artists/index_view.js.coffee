Arto.Views.Artists ||= {}

class Arto.Views.Artists.IndexView extends Backbone.View
  template: JST["backbone/templates/artists/index"]

  initialize: () ->
    @options.artists.bind('reset', @addAll)

  addAll: () =>
    @options.artists.each(@addOne)

  addOne: (artist) =>    
    view = new Arto.Views.Artists.ArtistView({model : artist})
    artistContent = $(view.render().el)
    $("#artists").append(artistContent).masonry('appended', artistContent);
    $("#artists").masonry('reload');

  render: =>
    @addAll()
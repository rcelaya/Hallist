Arto.Views.Artists ||= {}

class Arto.Views.Artists.ArtistView extends Backbone.View
  template: JST["backbone/templates/artists/artist"]

  className: 'artist'

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this

class Arto.Models.Artist extends Backbone.Model
  paramRoot: 'artist'

  defaults: {}

class Arto.Collections.ArtistsCollection extends Backbone.Collection
  model: Arto.Models.Artist
  url: '/artists.json'

  page: 1
  
  filters: {}
  
  fetchNext: ->
    params = {data: { page: @page}}
    params['data']['filters'] = @filters if !_.isEmpty(@filters)
    @fetch(params)
    @page = @page + 1
  
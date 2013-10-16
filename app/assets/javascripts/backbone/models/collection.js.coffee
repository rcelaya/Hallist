class Arto.Models.Collection extends Backbone.Model
  paramRoot: 'collection'

  defaults: {}

class Arto.Collections.CollectionsCollection extends Backbone.Collection
  model: Arto.Models.Collection
  url: '/collections.json'
  
  page: 1
  
  filters: {}
  
  fetchNext: ->
    params = {data: { page: @page}}
    params['data']['filters'] = @filters if !_.isEmpty(@filters)
    @fetch(params)
    @page = @page + 1

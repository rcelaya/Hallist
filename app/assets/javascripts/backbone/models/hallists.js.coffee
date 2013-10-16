class Arto.Models.Hallists extends Backbone.Model
  paramRoot: 'hallist'

  defaults: {}

class Arto.Collections.HallistsCollection extends Backbone.Collection
  model: Arto.Models.Hallists
  url: '/hallists.json'

  page: 1
  
  filters: {}
  
  fetchNext: ->
    params = {data: { page: @page}}
    params['data']['filters'] = @filters if !_.isEmpty(@filters)
    @fetch(params)
    @page = @page + 1
  

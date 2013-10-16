class Arto.Models.Product extends Backbone.Model
  paramRoot: 'product'
  
  url: ->
    "/products/#{@get('permalink')}.json"
  
  defaults:
    id: null
    name: null
    image: null
    price: null
    permalink: null
    collection_button: null
    like_button: null
    brandName: null
    description: null
    variants:
      original:
        price: null
        id: null
      prints: [{id: null, name: null, size: null, price: null}]

class Arto.Collections.ProductsCollection extends Backbone.Collection
  model: Arto.Models.Product
  url: '/products.json'
  
  page: 1
  
  filters: {}
  
  initialize: ->
    this.bind('reset', @checkLength)
    
  
  checkLength: ->
    if this.length == 0
      # window.scrollInfinite.bottomOfPage()
      window.scrollInfinite.page = 1
      @page = 1

  fetchNext: ->
    params = {data: { page: @page}}
    params['data']['filters'] = @filters if !_.isEmpty(@filters)
    @fetch(params)
    @page = @page + 1
  
  fetchNextProfile: (profile_id) ->
    @url = "/profile/#{profile_id}/products.json"
    params = {data: { page: window.profile_artworks_page}}
    @fetch(params)
    window.profile_artworks_page = window.profile_artworks_page + 1

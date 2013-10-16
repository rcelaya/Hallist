class Arto.Routers.ProductsRouter extends Backbone.Router
  initialize: (options) ->
    @products = new Arto.Collections.ProductsCollection()
    @options = options || {}

  routes:
    "index"                           : "index"
    "artworks/:id"                    : "show"
    ".*"                              : "index"
    "color/:color"                    : "colorIndex"
    "price/:price_from/:price_to"     : "priceIndex"
    "price/:price_from"               : "priceIndex"
    "category/:category"              : "categoryIndex"
    "search/:search"                  : "searchIndex"
    "_=_"                             : "index"
    "profile/:id"                     : "index"

  index: (first_param, second_param)->
    @products = new Arto.Collections.ProductsCollection()
    @resetIndex('index', null)
    @renderIndex()

  colorIndex: (color) ->
    @products = new Arto.Collections.ProductsCollection()
    @resetIndex('colorIndex', color)
    @products.filters['property_values_id'] = color
    @renderIndex()

  priceIndex: (price_from, price_to) ->
    @products = new Arto.Collections.ProductsCollection()
    @resetIndex('priceIndex', [price_from, price_to])
    @products.filters['price'] = {from: price_from, to: price_to}
    @renderIndex()

  categoryIndex: (category) ->
    @products = new Arto.Collections.ProductsCollection()
    @resetIndex('categoryIndex', category)
    @products.filters['product_type_id'] = category
    @renderIndex()

  searchIndex: (search) ->
    @products = new Arto.Collections.ProductsCollection()
    @resetIndex('searchIndex', search)
    @products.filters['search'] = search
    @renderIndex()

  show: (id) -> 
    product = new Arto.Models.Product({permalink: id})
    product.fetch {
      success: =>
        @view = new Arto.Views.Products.ShowView(model: product)
        $("#artwork-details-modal").html(@view.render().el)
        $('#artwork-details-modal').modal({ dynamic: true })
        FB.XFBML.parse();
        twttr.widgets.load();
        # @loadCommenView(product.get('id'))
        # @loadComments(product.get('id'))
    }
    
    if (window.scrollInfinite.initialized == false)
      @products = new Arto.Collections.ProductsCollection()
      @resetIndex('show', null)
      @renderIndex()
      window.scrollInfinite.initialize() if window.scrollInfinite.initialized == false
    
  loadCommenView: (product_id) ->
    @comments = new Arto.Collections.CommentsCollection()
    @view = new Arto.Views.Comments.NewView(collection: @comments, commentable_id: product_id)
    $("#comment-form").html(@view.render().el)
  
  loadComments: (product_id) ->
    @comments = new Arto.Collections.CommentsCollection()
    @comments.fetch 
      data: {product_id: product_id}
      success: =>
        @comments.each (comment) ->
          view = new Arto.Views.Comments.CommentView({model : comment})
          $("#comments").append(view.render().el)

  renderIndex: ->
    if _.isUndefined(@options.products)
      @products.fetchNext()
    else
      @products.reset @options.products
    @view = new Arto.Views.Products.IndexView(products: @products)
    @view.renderProducts()
    window.scrollInfinite.initialize() if window.scrollInfinite.initialized == false
  
  resetIndex: (actualIndex, actualFilter) ->
    if (actualIndex != @actualIndex) or (actualFilter != @actualFilter)
      if _.isUndefined(@options.products)
        $("#products").html('') 
        @products.page = 1
      else
        @products.page = 2
      @actualFilter = actualFilter
      @actualIndex = actualIndex
      @products.filters = {}
      @products.reset()
      

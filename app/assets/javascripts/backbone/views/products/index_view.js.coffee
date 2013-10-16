Arto.Views.Products ||= {}

class Arto.Views.Products.IndexView extends Backbone.View
  template: JST["backbone/templates/products/index"]

  initialize: () ->
    @options.products.bind('reset', @addAll)

  addAll: () =>
    @options.products.each(@addOne)
    window.scrollInfinite.ajaxComplete()

  addOne: (product) =>
    view = new Arto.Views.Products.ProductView({model : product})
    productContent = $(view.render().el)
    $("#products").append(productContent).masonry('appended', productContent)
    $("#products").masonry('reload')

  renderProducts: ->
    @addAll()
  
  

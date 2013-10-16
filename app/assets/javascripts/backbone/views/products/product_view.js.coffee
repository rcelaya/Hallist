Arto.Views.Products ||= {}

class Arto.Views.Products.ProductView extends Backbone.View
  template: JST["backbone/templates/products/product"]

  events:
    "click a" : "clicked"

  className: 'product'

  destroy: () ->
    @model.destroy()
    this.remove()

    return false
  
  clicked: (event) ->
    href = $(event.currentTarget).attr('href')
    
    if !event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey
      event.preventDefault()
      url = href.replace(/^\//,'').replace('\#\!\/','')

      window.router.navigate url, { trigger: true }

      return false

  render: ->
    @setClassName()
    $(@el).html(@template(@model.toJSON() ))
    return this

  setClassName: ->
    $(@el).addClass('no-product') if _.isEmpty(@model.get('brand_name'))
      
    
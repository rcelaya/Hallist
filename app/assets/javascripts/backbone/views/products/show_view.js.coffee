Arto.Views.Products ||= {}

class Arto.Views.Products.ShowView extends Backbone.View
  template: JST["backbone/templates/products/show"]
  
  render: ->
    JSONmodel = @model.toJSON();
    JSONmodel.product_url = document.URL;
    $(@el).html(@template(JSONmodel))
    return this

Arto.Views.Collections ||= {}

class Arto.Views.Collections.CollectionView extends Backbone.View
  template: JST["backbone/templates/collections/collection"]

  className: 'collection'

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this

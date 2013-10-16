Arto.Views.Hallists ||= {}

class Arto.Views.Hallists.HallistsView extends Backbone.View
  template: JST["backbone/templates/hallists/hallists"]

  className: 'hallist'

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
    

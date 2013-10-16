Arto.Views.Hallists ||= {}

class Arto.Views.Hallists.IndexView extends Backbone.View
  template: JST["backbone/templates/hallists/index"]

  initialize: () ->
    @options.hallists.bind('reset', @addAll)

  addAll: () =>
    @options.hallists.each(@addOne)

  addOne: (hallist) =>    
    view = new Arto.Views.Hallists.HallistsView({model : hallist})
    hallistContent = $(view.render().el)
    $("#hallists").append(hallistContent).masonry('appended', hallistContent);
    $("#hallists").masonry('reload');

  render: =>
    @addAll()

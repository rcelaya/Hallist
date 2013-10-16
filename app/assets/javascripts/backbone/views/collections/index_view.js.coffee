Arto.Views.Collections ||= {}

class Arto.Views.Collections.IndexView extends Backbone.View
  template: JST["backbone/templates/collections/index"]

  initialize: () ->
    @options.collections.bind('reset', @addAll)

  addAll: () =>
    @options.collections.each(@addOne)
    window.scrollInfinite.ajaxComplete()

  addOne: (collection) =>
    view = new Arto.Views.Collections.CollectionView({model : collection})
    collectionContent = $(view.render().el)
    $("#collections").append(collectionContent ).masonry('appended', collectionContent );
    $("#collections").masonry('reload');

  render: =>
    @addAll()

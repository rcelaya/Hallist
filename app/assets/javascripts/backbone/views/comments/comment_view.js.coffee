Arto.Views.Comments ||= {}

class Arto.Views.Comments.CommentView extends Backbone.View
  template: JST["backbone/templates/comments/comment"]

  className: 'comment'

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this

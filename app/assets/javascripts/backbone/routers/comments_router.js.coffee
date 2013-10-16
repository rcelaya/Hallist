class Arto.Routers.CommentsRouter extends Backbone.Router
  initialize: (options) ->
    @comments = new Arto.Collections.CommentsCollection()
    @comments.reset options.comments

  routes:
    "index"    : "index"
    ".*"        : "index"

  newComment: ->
    @view = new Arto.Views.Comments.NewView(collection: @comments)
    $("#comments").html(@view.render().el)

  index: ->
    @view = new Arto.Views.Comments.IndexView(comments: @comments)
    $("#comments").html(@view.render().el)

  show: (id) ->
    comment = @comments.get(id)

    @view = new Arto.Views.Comments.ShowView(model: comment)
    $("#comments").html(@view.render().el)

  edit: (id) ->
    comment = @comments.get(id)

    @view = new Arto.Views.Comments.EditView(model: comment)
    $("#comments").html(@view.render().el)

Arto.Views.Comments ||= {}

class Arto.Views.Comments.NewView extends Backbone.View
  template: JST["backbone/templates/comments/new"]
  commentTemplate: JST["backbone/templates/comments/comment"]

  events:
    "submit #new-comment": "save"
    "focusin #comment_note" : "showButton"

  constructor: (options) ->
    super(options)
    @model = new @collection.model(commentable_id: options['commentable_id'])

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    if window.current_user
      @collection.create(@model.toJSON(),
        success: (comment) =>
          @model = comment
          commentView = new Arto.Views.Comments.CommentView({model : @model})
          $('#comments').prepend(commentView.render().el)
          @loadCommentForm(@model.get('commentable_id'))

        error: (comment, jqXHR) =>
          @model.set({errors: $.parseJSON(jqXHR.responseText)})
      )
    else
      window.openLoginModal()

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this

  showButton: ->
    $('#submit-comment').show();

  loadCommentForm: (product_id) ->
    @view = new Arto.Views.Comments.NewView(collection: @collection, commentable_id: product_id)
    $("#comment-form").html(@view.render().el)
    
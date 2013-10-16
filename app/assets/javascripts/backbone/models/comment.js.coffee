class Arto.Models.Comment extends Backbone.Model
  paramRoot: 'comment'

  defaults:
    commentable_type: 'Product'
    commentable_id: null
    note: null

class Arto.Collections.CommentsCollection extends Backbone.Collection
  model: Arto.Models.Comment
  url: '/comments'

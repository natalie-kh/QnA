module SearchHelper
  def get_comment_question(resource)
    if resource.commentable_type == 'Question'
      [resource.commentable.title, resource.commentable]
    else
      [resource.commentable.body, resource.commentable.question]
    end
  end
end

class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :created_at, :updated_at

  has_many :comments do
    object.comments.order(:id)
  end

  has_many :links do
    object.links.order(:id)
  end

  has_many :files, serializer: AttachmentSerializer
end

class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :short_title, :created_at, :updated_at

  has_many :answers do
    object.answers.order(:id)
  end

  belongs_to :user

  def short_title
    object.title.truncate(7)
  end
end

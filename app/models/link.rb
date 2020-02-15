class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: URI.regexp(%w[http https])

  default_scope { order(created_at: :asc) }

  def gist?
    url.match?(%r{^https://gist\.github\.com/.*/.*})
  end
end

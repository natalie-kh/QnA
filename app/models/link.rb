class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: URI::regexp(%w[http https])

  def gist?
    url.match?(/^https:\/\/gist\.github\.com\/.*\/.*/)
  end

  def gist_content
    GistService.new(url).call
  end
end

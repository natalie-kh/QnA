class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: URI::regexp(%w[http https])

  def gist?
    url.match?(/^https:\/\/gist\.github\.com\/.*\/.*/)
  end

  def gist_content
    if gist?
      array = GistService.new(url).call
      array&.map { |array| array[0].upcase + "\n" + array[1]}&.join("\n\n") || 'Gist not Found'
    end
  end
end

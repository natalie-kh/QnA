class SearchService
  attr_reader :query, :klass

  RESOURCES = %w[Questions Answers Comments Users].freeze

  def initialize(query, resource = nil)
    @query = ThinkingSphinx::Query.escape(query)
    @klass = RESOURCES.include?(resource) ? resource.classify.constantize : ThinkingSphinx
  end

  def call
    klass.search query
  end
end

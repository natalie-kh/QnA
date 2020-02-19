class SearchService

  RESOURCES = %w[Questions Answers Comments Users].freeze

  def self.call(query: query, resource: nil)
    klass = RESOURCES.include?(resource) ? resource.classify.constantize : ThinkingSphinx
    klass.search ThinkingSphinx::Query.escape(query)
  end
end

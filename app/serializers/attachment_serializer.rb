class AttachmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :filename, :path

  def filename
    object.name
  end

  def path
    rails_blob_path(object, only_path: true)
  end
end

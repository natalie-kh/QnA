class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  authorize_resource

  def destroy
    @attachment.purge
  end

  private

  def load_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end

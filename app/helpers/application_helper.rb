module ApplicationHelper
  def alert_class(key)
    { success: 'alert-success', alert: 'alert-danger', notice: 'alert-info' }[key.to_sym]
  end
end

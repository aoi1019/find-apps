class NotificationsController < ApplicationController
  before_action :logged_in_user

  def index
    @notifications = current_user.notifications.order("created_at DESC")
    current_user.update_attribute(:notification, false)
  end
end

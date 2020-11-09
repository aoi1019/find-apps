class FavoritesController < ApplicationController
  before_action :logged_in_user

  def index
    @favorites = current_user.favorites.order("created_at DESC")
  end

  def create
    @app = App.find(params[:app_id])
    @user = @app.user
    current_user.favorite(@app)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_path }
      format.js
    end

    if @user != current_user
      @user.notifications.create(app_id: @app.id, variety: 1, from_user_id: current_user.id)
      @user.update_attribute(:notification, true)
    end
  end

  def destroy
    @app = App.find(params[:app_id])
    current_user.favorites.find_by(app_id: @app.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_path }
      format.js
    end
  end
end

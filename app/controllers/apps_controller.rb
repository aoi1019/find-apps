class AppsController < ApplicationController
  before_action :logged_in_user
  
  def new
    @app = App.new
  end
end

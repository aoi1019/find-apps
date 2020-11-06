class AppsController < ApplicationController
  before_action :logged_in_user

  def new
    @app = App.new
  end

  def create
    @app = current_user.apps.build(app_params)
    if @app.save
      flash[:success] = "アプリが登録されました！"
      redirect_to app_path(@app)
    else
      render :new
    end
  end

  def show
    @app = App.find(params[:id])
  end

  private
    def app_params
      params.require(:app).permit(:name, :description, :point, :period, :reference)
    end
end

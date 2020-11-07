class AppsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update]

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

  def edit
    @app = App.find(params[:id])
  end

  def update
    @app = App.find(params[:id])
    if @app.update(app_params)
      flash[:success] = "アプリ情報が更新されました！"
      redirect_to @app
    else
      render :edit
    end
  end

  def destroy
    @app = App.find(params[:id])
    if current_user.admin? || current_user?(@app.user)
      @app.destroy
      flash[:success] = "アプリが削除されました"
      redirect_to request.referrer == user_url(@app.user) ? user_url(@app.user) : root_url
    else
      flash[:danger] = "他人のアプリは削除できません"
      redirect_to root_url
    end
  end

  private

    def app_params
      params.require(:app).permit(:name, :description, :point, :period, :reference, :picture)
    end

    def correct_user
      @app = current_user.apps.find_by(id: params[:id])
      redirect_to root_url if @app.nil?
    end
end

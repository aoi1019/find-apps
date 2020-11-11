class LogsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: :create

  def create
    @app = App.find(params[:app_id])
    @log = @app.logs.build(content: params[:log][:content])
    @log.save
    flash[:success] = "開発ログを追加しました！"
    redirect_to app_path(@app)
  end

  def destroy
    @log = Log.find(params[:id])
    @app = @log.app
    if current_user == @app.user
      @log.destroy
      flash[:success] = "開発ログを削除しました"
    end
    redirect_to app_path(@app)
  end

  private

    def correct_user
      app = current_user.apps.find_by(id: params[:app_id])
      redirect_to root_path if app.nil?
    end
end

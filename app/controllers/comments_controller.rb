class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @app = App.find(params[:app_id])
    @user = @app.user
    @comment = @app.comments.build(user_id: current_user.id, content: params[:comment][:content])
    if !@app.nil? && @comment.save
      flash[:success] = "コメントを追加しました！"
    else
      flash[:danger] = "空のコメントは投稿できません。"
    end
    redirect_to request.referrer || root_url
  end

  def destroy
    @comment = Comment.find(params[:id])
    @app = @comment.app
    if current_user.id == @comment.user_id
      @comment.destroy
      flash[:success] = "コメントを削除しました"
    end
    redirect_to app_path(@app)
  end

end
class ContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_content, only: [:show, :edit, :update, :destroy]

  def index
    @contents = current_user.contents
  end

  def show
  end

  def new
    @content = current_user.contents.build
  end

  def create
    @content = current_user.contents.build(content_params)
    if @content.save
      redirect_to user_contents_path(current_user), notice: '案件内容が作成されました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @content.update(content_params)
      redirect_to user_contents_path(current_user), notice: '案件内容が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @content.destroy
    redirect_to user_contents_path(current_user), notice: '案件内容が削除されました。'
  end

  private

  def set_content
    @content = current_user.contents.find(params[:id])
  end

  def content_params
    params.require(:content).permit(:name, :description)
  end
end

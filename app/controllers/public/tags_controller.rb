class Public::TagsController < ApplicationController
  def create
  end

  def show
    @tag = Tag.find(params[:id])
    @tags = Tag.where(user_id: current_user.id)
    @manuals = @tag.manuals.page(params[:page])
    if @manuals.count == 0
      @list_title = "「#{@tag.name}」 の該当なし"
    else
      @list_title = "#{@tag.name} の検索結果一覧 （全 #{@manuals.count}件）"
    end
    render 'public/manuals/index'
  end

  def destroy
  end

end

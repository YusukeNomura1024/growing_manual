class Public::TagsController < ApplicationController
  def create
  end

  def show
    @tag = Tag.find(params[:id])
    # ターゲットがeveryoneの場合
    if params[:target] == 'everyone'
      @tags = Tag.all
      @manuals = @tag.manuals.where(status: true).page(params[:page])
      list_title_set

      render 'public/homes/top'

    # targetが自分の場合
    else
      @tags = Tag.where(user_id: current_user.id)
      @manuals = @tag.manuals.where(user_id: current_user.id).page(params[:page])
      list_title_set

      render 'public/manuals/index'
    end
  end

  def destroy
  end

  def list_title_set
    if @manuals.count == 0
      @list_title = "「#{@tag.name}」 の該当なし"
    else
      @list_title = "#{@tag.name} の検索結果一覧 （全 #{@manuals.count}件）"
    end
  end

end

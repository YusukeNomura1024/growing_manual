class Admin::TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @tags = Tag.all
    @manuals = @tag.manuals.preload(:bookmarks, :reviews, :user, :bookmarked_users).page(params[:page])
    list_title_set

    render 'admin/manuals/index'

  end

  def list_title_set
    if @manuals.count == 0
      @list_title = "「#{@tag.name}」 の該当なし"
    else
      @list_title = "#{@tag.name} の検索結果一覧 （全 #{@manuals.count}件）"
    end
  end
end

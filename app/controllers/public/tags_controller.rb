class Public::TagsController < ApplicationController

  before_action :authenticate_user!, except: [:top, :about, :show]

  def create
  end

  def show

    # ターゲットがeveryoneの場合
    if params[:target] == 'everyone'
      @search_tags = Tag.where(name: params[:id])
      @search_tag_ids = @search_tags.each {|search_tag| search_tag.id }
      @tags = Manual.joins(:tags).group("tags.name").order('count_all DESC').count
      @manuals = []
      TagMap.preload(:manual).where(tag_id: @search_tag_ids).each do |tag_map|
        @manuals << tag_map.manual
      end
      @manuals = Manual.preload(:bookmarked_users, :user, :reviews).where(id: @manuals.map(&:id))
      @manuals = Kaminari.paginate_array(@manuals).page(params[:page])
      public_list_title_set

      render 'public/homes/top'

    # targetが自分の場合
    else
      @tag = Tag.find(params[:id])
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

  def public_list_title_set
    if @manuals.count == 0
      @list_title = "[#{params[:id]}」の該当なし"
    else
      @list_title = "#{params[:id]} の検索結果一覧 （全 #{@manuals.count}件）"
    end
  end

end

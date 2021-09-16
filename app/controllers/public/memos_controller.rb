class Public::MemosController < ApplicationController
  def index
    @categories = Category.where(user_id: current_user)
    @memos = Memo.where(user_id: current_user.id).page(params[:page]).reverse_order

  end

  def search
    @categories = Category.where(user_id: current_user)
    @memos = Memo.where(user_id: current_user.id).page(params[:page]).reverse_order
    if @memos.count == 0
      @list_title = "「#{params[:keyword]}」 の該当なし"
    else
      @list_title = "#{params[:keyword]} の検索結果一覧 （全 #{@memos.count}件）"
    end
    render :index
  end

  def show
    @memo = Memo.find(params[:id])
  end

  def link

    @memo = Memo.find(params[:id])
    @memo_link = MemoLink.new

  end

  def new
    @memo = Memo.new
    @categories = Category.where(user_id: current_user.id)
    @category = Category.new
  end

  def create
    @memo = Memo.new(memo_params)
    if params[:preview_button]
      @categories = Category.where(user_id: current_user.id)
      @category = Category.new
      render :new
    else
      @memo.save
      redirect_to memos_path
      if !params[:memo][:procedure_id].nil?
        memo_link = MemoLink.new
        memo_link.procedure_id = params[:memo][:procedure_id]
        memo_link.memo_id = @memo.id
        memo_link.save
      end
    end
  end

  def edit
    @memo = Memo.find(params[:id])
    @categories = Category.where(user_id: current_user.id)
    @category = Category.new

  end

  def update
    @memo = Memo.find(params[:id])
    if !params[:preview_button].nil?
      @memo = Memo.new(memo_params)
      @categories = Category.where(user_id: current_user.id)
      @category = Category.new
      render :edit
    else

      @memo.update(memo_params)
      redirect_to memo_path(@memo)
    end

  end

  def destroy
  end

private

  def memo_params
    params.require(:memo).permit(:category_id, :name, :description, :url, :code).merge(user_id: current_user.id)
  end

end

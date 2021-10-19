class Public::ManualsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :non_owner_to_root, only: [:destroy, :update, :edit]

  def index
    @tags = Tag.where(user_id: current_user.id)
    if params[:sort] == 'created_at' || params[:sort].nil?
      @manuals = Manual.where(user_id: current_user.id).page(params[:page]).reverse_order
      params[:sort] = 'created_at'
    elsif params[:sort] == 'bookmarks'
      @manuals = Manual.includes(:bookmarked_users).where(user_id: current_user).sort {|a,b| b.bookmarked_users.size <=> a.bookmarked_users.size}
      @manuals = Kaminari.paginate_array(@manuals).page(params[:page])
    end
  end

  def show
    @manual = Manual.find(params[:id])
    @procedures = @manual.procedures
    @user = current_user
    @message = Message.new
    respond_to do |format|
      format.html

      format.js { render 'show' }
    end
    
  end

  def new
    @manual = Manual.new

  end

  def create
    @manual = Manual.new(manual_params)
    @manual.save

    redirect_to manual_procedures_path(@manual)
    tag_list = params[:manual][:tag_name].split(nil)
    if @manual.save
      @manual.save_manuals(tag_list)
    end
  end

  def edit
    @manual = Manual.find(params[:id])
    @procedures = @manual.procedures
    @user = current_user
    @message = Message.new
    @tag_names = @manual.tags.map { |tag| tag.name}.join(' ')


  end

  def update
    manual = Manual.find(params[:id])
    tag_list = params[:manual][:tag_name].split(nil)



    if manual.update(manual_params)
      manual.save_manuals(tag_list)
      redirect_to manual_path(manual)
    else
      render :edit
    end
  end

  def destroy
    manual = Manual.find(params[:id])
    manual.destroy
    redirect_to manuals_path
  end

  def sort
    @manual = Manual.find(params[:id])
    procedure = @manual.procedures[params[:from].to_i]
    procedure.insert_at(params[:to].to_i + 1)
    head :ok
  end

  def search
    # みんなのマニュアルを表示させる場合はtargetがeveryone
    if params[:target] == 'everyone'
      @tags = Tag.all
      @manuals = Manual.where(status: true).search(params[:keyword]).page(params[:page]).reverse_order
      list_title_set

      render 'public/homes/top'
    else
      @tags = Tag.where(user_id: current_user.id)
      @manuals = Manual.where(user_id: current_user.id).search(params[:keyword]).page(params[:page])
      list_title_set

      render :index
    end


  end

  def non_owner_to_root
    @manual = Manual.find(params[:id])
    unless current_user.id == @manual.user_id || admin_user_signed_in?
      redirect_to '/'
    end
  end

  private

  def manual_params
    params.require(:manual).permit(:title, :image, :description, :status, :release_date).merge(user_id: current_user.id)
  end

  def list_title_set
    if @manuals.count == 0
      @list_title = "「#{params[:keyword]}」 の該当なし"
    else
      @list_title = "#{params[:keyword]} の検索結果一覧 （全 #{@manuals.count}件）"
    end
  end

end

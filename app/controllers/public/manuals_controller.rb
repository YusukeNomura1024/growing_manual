class Public::ManualsController < ApplicationController
  def index
    @tags = Tag.where(user_id: current_user.id)
    @manuals = Manual.where(user_id: current_user.id).page(params[:page]).reverse_order
  end

  def show
    @manual = Manual.find(params[:id])
    @procedures = @manual.procedures
    @user = current_user
    @message = Message.new
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
  end

  def update
    manual = Manual.find(params[:id])
    manual.update(manual_params)
    redirect_to manual_path(manual)
    tag_list = params[:manual][:tag_name].split(nil)
    if manual.update(manual_params)
      manual.save_manuals(tag_list)
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
      @manuals = Manual.where(status: true).page(params[:page]).reverse_order
      list_title_set

      render 'public/homes/top'
    else
      @tags = Tag.where(user_id: current_user.id)
      @manuals = Manual.where(user_id: current_user.id).search(params[:keyword]).page(params[:page])
      list_title_set

      render :index
    end


  end

  def manual_params
    params.require(:manual).permit(:title, :image_id, :description, :status, :release_date).merge(user_id: current_user.id)
  end

  def list_title_set
    if @manuals.count == 0
      @list_title = "「#{params[:keyword]}」 の該当なし"
    else
      @list_title = "#{params[:keyword]} の検索結果一覧 （全 #{@manuals.count}件）"
    end
  end

end

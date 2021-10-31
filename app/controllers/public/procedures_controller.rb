class Public::ProceduresController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]

  def index
    @manual = Manual.find(params[:manual_id])
    non_manual_owner_to_root
    @procedures = @manual.procedures
    @procedure = Procedure.new
  end

  def create
    @procedure = Procedure.new(procedure_params)
    @manual = Manual.find(params[:manual_id])
    @procedures = @manual.procedures
    @procedure.manual_id = @manual.id
    non_manual_owner_to_root
    max_position = Procedure.where(manual_id: @manual.id).maximum(:position)

    # 一度もprocedureを作成していない場合の処理
    if max_position.nil?
      @procedure.position = 1
    end
    if @procedure.save
      flash[:notice] = "登録しました"
      redirect_to manual_procedures_path(@manual)
    else
      flash.now[:alert] = "登録できませんでした"
      render :index
    end
  end

  def destroy
    procedure = Procedure.find(params[:id])
    @manual = Manual.find(params[:manual_id])
    non_manual_owner_to_root
    if procedure.destroy
      flash[:notice] = "削除しました"
    else
      flash[:alert] = "削除できませんでした"
    end
    redirect_to manual_procedures_path(params[:manual_id])
  end

  def edit
    @manual = Manual.find(params[:manual_id])
    non_manual_owner_to_root
    @procedure = Procedure.find(params[:id])

  end

  def update
    @manual = Manual.find(params[:manual_id])
    non_manual_owner_to_root
    @procedure = Procedure.find(params[:id])

    if @procedure.update(procedure_params)
      flash[:notice] = "更新しました"
    else
      flash[:alert] = "更新できませんでした#{@procedure.errors.full_messages}"
    end
    redirect_to manual_procedures_path(@procedure.manual.id)

  end


  private

  def non_manual_owner_to_root
    if @manual.user != current_user
      redirect_to '/'
    end
  end

  def procedure_params
    params.require(:procedure).permit(:title, :position)
  end

end

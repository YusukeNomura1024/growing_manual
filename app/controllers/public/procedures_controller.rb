class Public::ProceduresController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
  
  def index
    @manual = Manual.find(params[:manual_id])
    @procedures = @manual.procedures
  end

  def create

    procedure = Procedure.new(procedure_params)
    procedure.manual_id = params[:manual_id]
    max_position = Procedure.where(manual_id: params[:manual_id]).maximum(:position)
    if max_position.nil?
      procedure.position = 1

    end
    procedure.save
    redirect_to manual_procedures_path(params[:manual_id])
  end

  def destroy
    procedure = Procedure.find(params[:id])
    procedure.destroy
    redirect_to manual_procedures_path(params[:manual_id])
  end

  def edit
    @procedure = Procedure.find(params[:id])
    @manual = Manual.find(params[:manual_id])

  end

  def update
    procedure = Procedure.find(params[:id])
    procedure.update(procedure_params)
    redirect_to manual_procedures_path(procedure.manual.id)
  end

  private

  def procedure_params
    params.require(:procedure).permit(:title, :position)
  end

end

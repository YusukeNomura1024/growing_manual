class Public::ManualsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @manual = Manual.new

  end

  def create
    @manual = Manual.new(manual_params)
    @manual.save

    redirect_to manual_procedures_path(@manual)
    tag_list = params[:tag_name].split(nil)
    if @manual.save
      @manual.save_manuals(tag_list)
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

end

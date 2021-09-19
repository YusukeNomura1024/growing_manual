class Public::HomesController < ApplicationController
  def top
    @tags = Tag.all
    @manuals = Manual.where(status: true).page(params[:page]).reverse_order
  end

  

  def about
  end
end

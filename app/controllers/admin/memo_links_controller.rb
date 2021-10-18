class Admin::MemoLinksController < ApplicationController
  
  def show
    @memo_link = MemoLink.find(params[:id])
    respond_to do |format|
      format.html

      format.js { render 'show' }
    end
  end
  
end

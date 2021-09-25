class Admin::HomesController < ApplicationController
  def messages
    @messages = Message.where.not(type: 'from_admin', is_replied: true)
  end
  

end

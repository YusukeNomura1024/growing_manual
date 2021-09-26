module ListFilter
extend ActiveSupport::Concern

  def where_user_id_is_current_user_id(model)
    model.where(user_id: current_user.id)
  end


end

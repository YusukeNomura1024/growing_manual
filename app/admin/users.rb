ActiveAdmin.register User do

  permit_params do
    permitted = [:email, :encrypted_password, :full_name, :pen_name, :image_id, :is_active, :reset_password_token, :reset_password_sent_at, :remember_created_at, :id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  filter :full_name
  filter :email
  filter :is_active, collection:{"有効" => true, "無効" => false}




  action_item :messages, only: :show do
    link_to 'メッセージ一覧に飛びます', admin_user_messages_path(user)
  end


  show do
    attributes_table do
      row(:full_name)
      row(:pen_name)
      row(:email)
      row(:bookmarked) do |user|
        user.bookmarked_count
      end
      row(:is_active) do |user|
        user.status_text
      end
      row(:created_at) do |user|
        user.created_at.strftime('%Y年%m月%d日')
      end
    end
  end

  index do
    selectable_column
    column(:id)
    column(:full_name) do |user|
      link_to "#{user.full_name}", "/admin/users/#{user.id}"
    end
    column(:pen_name)
    column(:email)
    column(:is_active) do |user|
      user.status_text
    end
    column(:bookmarked) do |user|
      user.bookmarked_count
    end
    column(:created_at) do |user|
      user.created_at.strftime('%Y年%m月%d日')
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :full_name
      f.input :pen_name
      f.input :email
      f.input :is_active, as: :select, collection:{"有効" => true, "無効" => false}
      f.input :reset_password_token
    end
    f.actions
  end

end

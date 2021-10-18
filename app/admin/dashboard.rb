ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "問い合わせ一覧(#{Message.contact.not_reply.count}件)" do
          ul class: "scrollbars" do
            Message.contact.not_reply.map do |message|
              li link_to("#{message.created_at.strftime('%Y/%m/%d')}:from:#{message.user.full_name}::#{message.comment[0, 100]}", admin_user_messages_path(message.user_id)), class: "admin_message_list_group__item"
            end
          end
        end

      end

      column do
        panel "違反報告一覧(#{Message.violation_report.not_reply.count}件)" do
          ul class: "scrollbars" do
            Message.violation_report.not_reply.map do |message|
              li class: "admin_message_list_group__item" do
                ul do
                  li "#{message.created_at.strftime('%Y/%m/%d')}", class: "list_group__item_row"
                  li link_to("target:#{message.report_target}", "#{message.report_target_admin_link}"), class: "list_group__item_row"
                  li link_to("from:#{message.user.full_name}::#{message.comment[0, 100]}", admin_user_messages_path(message.user_id)), class: "list_group__item_row"
                end
              end
            end
          end
        end
      end

    end


  end
end

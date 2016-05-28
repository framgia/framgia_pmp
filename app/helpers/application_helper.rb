module ApplicationHelper
  def full_title page_title = ""
    base_title = t "project_name"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def flash_class level
    case level
    when :notice then "alert-info"
    when :error then "alert-error"
    when :alert then "alert-warning"
    when :success then "alert-success"
    end
  end

  def activity_class activity
    assignee = activity.user
    estimate = activity.estimate.nil? ? 0 : activity.estimate
    remaining = activity.log_works.empty? ? 0 : activity.log_works.last.remaining_time

    if assignee.nil?
      estimate != 0 ? (remaining != 0 ? "estimated" : "default") : "default"
    else
      estimate != 0 ? (remaining != 0 ? "processed" : "default") : "assigned"
    end
  end

  def flash_message flash_type, *params
    if params.empty?
      t "flashs.messages.#{flash_type}", model_name: controller_name.classify
    else
      t "flashs.messages.#{flash_type}",
        models_name: params[0].join(", ") unless params[0].empty?
    end
  end

  def tab_active tab_name, current_tab
    current_tab == tab_name ? "active" : nil
  end

  def verity_admin?
    if current_user.member?
      redirect_to root_url
      flash[:success] = t "sessions.not_admin"
    end
  end

  def link_to_add_fields label, f, assoc
    new_obj = f.object.class.reflect_on_association(assoc).klass.new
    fields = f.fields_for assoc, new_obj, child_index: "new_#{assoc}" do |builder|
      render "shared/#{assoc.to_s.singularize}_fields", f: builder
    end
    link_to label, "#", onclick: "add_fields(this, \"#{assoc}\",
      \"#{escape_javascript(fields)}\")", remote: true
  end
end

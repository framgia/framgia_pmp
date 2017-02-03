class ProductBacklogPresenter < ActionView::Base
  include Rails.application.routes.url_helpers

  def initialize users
    @users = users
  end

  def render
    sidebar = Array.new
    body = Array.new
    @users.each_with_index do |user, index|
      sidebar << sidebar_item(user, index)
      body << body_item(user, index)
    end
    html = "<aside id=\"parent\" class=\"fixedTable-sidebar\">
      <div id=\"child\">
        <div id=\"table-sidebar\">
          <div class=\"tbody listsort filter_table_left_part\" id=\"list-records\">
    "
    html += sidebar.join("")
    html += "</div></div></div></aside>"

    html += "<div class=\"fixedTable-body tabel-scroll\">
      <div class=\"tbody listsort filter_table_right_part\">"
    html += body.join("")
    html += "</div></div>"
  end

  private
  def sidebar_item user, index
    "<div class=\"trow list_#{index}\" id=\"sidebar-row-#{user.id}\">
      <div class=\"tcell stt\">#</div>
      <div class=\"tcell name employee_name\" title=\"#{user.name}\">
      #{link_to user.name, "#"}
      </div>
    </div>
    "
  end

  def body_item user, index
    html = "<div class=\"trow #{"list_#{index}" }\" id=\"body-row-#{user.id}\">
      <div class=\"tcell trainee_type\" data-toogle=\"tooltip\" title=#{user.name}>
        #{user.name}
      </div>
      <div class=\"tcell location division\" data-toogle=\"tooltip\" title=#{user.name}>
        #{user.name}
      </div>
      <div class=\"tcell status text-center\" data-toogle=\"tooltip\" title=#{user.name}>
        #{user.name}
      </div>
      <div class=\"tcell university\" data-toogle=\"tooltip\" title=#{user.name}>
        #{user.name}
      </div>
      <div class=\"tcell graduation skill_name\">
      #{l user.created_at, format: :year_month if user.created_at}
      </div>
      <div class=\"tcell programming_language evaluation_rank_value \" data-toogle=\"tooltip\" title=#{user.name}>
        #{user.name}
      </div>
      <div class=\"tcell start_training_date text-right\">
        #{l user.created_at, format: :default if user.created_at}
      </div>
      <div class=\"tcell leave_date text-right\">
        #{l user.created_at, format: :default if user.created_at}
      </div>
      <div class=\"tcell finish_training_date text-right\">
        #{l user.created_at, format: :default if user.created_at}
      </div>
      <div class=\"tcell ready_for_project text-center\">
        #{ "ready"}
      </div>
      <div class=\"tcell contract_date text-right\">
        #{l user.created_at, format: :default if user.created_at}
      </div>
      <div class=\"tcell working_day text-right\">
        #{user.name}
      </div>
      <div class=\"tcell trainer\">
        #{link_to(user.name, "#",
          title: user.name) if user.name}
      </div>
      <div class=\"tcell current_progress\">
        #{"aaaa"}
      </div>
      <div class=\"tcell note\">
        #{"bbbb"}
      </div>"
    html += "<div class=\"tcell action\">
      #{link_to "edit", "#"}
      </div></div>"
  end
end

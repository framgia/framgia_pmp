class UsersDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari
  def_delegators :@view, :link_to, :user_path

  def initialize view
    @view = view
  end

  def as_json options = {}
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: User.count,
      iTotalDisplayRecords: users.total_count,
      aaData: data
    }
  end

  private
  def data
    users.each_with_index.map do |user, index|
      [
        index + 1,
        link_to(user.name,user_path(user)),
        user.email,
        user.role
      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.order "#{sort_column} #{sort_direction}"
    users = users.per_page_kaminari(page).per per_page
    if params[:sSearch].present?
      users = users.where "name like :search or email like :search", search: "%#{params[:sSearch]}%"
    end
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name email]
    columns[params[:iSortCol_1].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end

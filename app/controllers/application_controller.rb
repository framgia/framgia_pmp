class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :set_locale
  include ApplicationHelper

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to redirect_url
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def after_sign_in_path_for resource
    redirect_url
  end

  def redirect_url
    current_user.manager? ? admin_projects_url : root_url
  end
end
dfsdf

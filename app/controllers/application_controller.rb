class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  include ApplicationHelper

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      redirect_to root_url, alert: exception.message
    else
      redirect_to new_user_session_path, alert: t("flashs.user.mustlogin")
    end
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end

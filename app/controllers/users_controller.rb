class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.json {render json: UsersDatatable.new(view_context)}
    end
  end

  def update
    if @user.update_attributes user_params
      sign_in(@user, bypass: true)
      flash[:success] = flash_message "updated"
      redirect_to @user
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit User::USER_ATTRIBUTES_PARAMS
  end
end

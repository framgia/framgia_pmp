class Admin::WorkPerformancesController < ApplicationController
  include WorkPerformanceHelper
  load_and_authorize_resource
  load_and_authorize_resource :project
  load_and_authorize_resource :sprint

  def index
    @activities = @sprint.activities
    @data_performance_of_team = work_performance_of_team @sprint
  end

  def update
    respond_to do |format|
      if @work_performance.update performance_data_params
        format.json {head :no_content}
        format.js
      else
        format.json {render json: @customer.errors.full_messages,
          status: :unprocessable_entity}
      end
    end
  end

  private
  def performance_data_params
    params.require(:work_performance).permit WorkPerformance::ATTRIBUTES_PARAMS
  end
end

class ColumnsController < ApplicationController
  def create
    @master_sprint = MasterSprint.new master_sprint_params

    if @master_sprint.save
      @activities = @master_sprint.sprint.activities
      @assignees = @master_sprint.sprint.assignees
    end

    respond_to do |format|
      format.js
    end
  end

  private
  def master_sprint_params
    params.require(:master_sprint).permit :sprint_id
  end
end

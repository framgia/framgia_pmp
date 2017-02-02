class ProjectPhasesController < ApplicationController
  load_resource
  load_resource :project

  def destroy
    if @project_phase.destroy
      respond_to do |format|
        format.json do
          render json: {
            phase_id: @project_phase.phase_id,
            phase_name: @project_phase.phase_name
          }
        end
      end
    end
  end
end

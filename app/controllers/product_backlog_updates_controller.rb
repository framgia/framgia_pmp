class ProductBacklogUpdatesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def create
    @mode = params["!nativeeditor_status"]
    priority, estimate, actual, remaining = params[:c0], params[:c1],
      params[:c2], params[:c3]

    @id = params["gr_id"]

    case @mode
    when "deleted"
        ProductBacklog.find(@id).destroy
        @tid = @id

    when "updated"
      if @id.empty?
        product_backlog = ProductBacklog.create priority: priority, estimate: estimate,
          actual: actual,remaining: remaining
      else
        product_backlog = ProductBacklog.find @id
        product_backlog.update_attributes priority: priority, estimate: estimate,
          actual: actual, remaining: remaining
        product_backlog.save
        @tid = @id
      end
    end    
  end
end
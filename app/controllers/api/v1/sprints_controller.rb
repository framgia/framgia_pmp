class Api::V1::SprintsController < Api::BaseController
  load_and_authorize_resource

  def show
    json = {:sheetid=>"5", :config=>"",
      :readonly=>false, :head=>[],
      :cells=>[
        {:row=>"1", :col=>"1", :text=>"1", :calc=>"1", :style=>"0;0;000000;ffffff;left;none;0", :activity=>"123456789"},
        {:row=>"1", :col=>"2", :text=>"2", :calc=>"2", :style=>"0;0;000000;ffffff;left;none;0", :activity=>"00000"}]
      }
    render json: json
  end

  def update
    json = [{:row=>"1", :col=>7, :text=>"8", :calc=>"8", :type=>"updated"}]
    render json: json
  end
end

class Api::SprintsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def create
    json = {:sheetid=>"5", :config=>"", :readonly=>false, :head=>[], :cells=>[{:row=>"1", :col=>"1", :text=>"1", :calc=>"1", :style=>"0;0;000000;ffffff;left;none;0"}, {:row=>"1", :col=>"2", :text=>"2", :calc=>"2", :style=>"0;0;000000;ffffff;left;none;0"}]}
    render json: json
  end

  def show
    json = {:sheetid=>"5", :config=>"", :readonly=>false, :head=>[], :cells=>[{:row=>"1", :col=>"1", :text=>"1", :calc=>"1", :style=>"0;0;000000;ffffff;left;none;0"}, {:row=>"1", :col=>"2", :text=>"2", :calc=>"2", :style=>"0;0;000000;ffffff;left;none;0"}]}
    render json: json
  end
end

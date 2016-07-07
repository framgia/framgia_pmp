require "rails_helper"

RSpec.describe Sprint, type: :model do
  before{Fabricate(:sprint, project_id: 1)}

  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:start_date)}
  it {should have_many(:users).through(:assignees)}
  it {should have_many(:assignees).dependent(:destroy)}
  it {should have_many(:time_logs)}
  it {should have_many(:product_backlogs)}
  it {should have_many(:activities)}
  it {should have_many(:log_works)}
  it {should have_many(:master_sprints)}
  it {should belong_to(:project)}
  it {should accept_nested_attributes_for(:time_logs)}
  it {should accept_nested_attributes_for(:log_works)}
  it {should accept_nested_attributes_for(:master_sprints)}
  it {should accept_nested_attributes_for(:assignees)}
  it {should callback(:build_master_sprint).after(:create)}

end

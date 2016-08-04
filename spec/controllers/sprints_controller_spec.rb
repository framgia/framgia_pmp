require "rails_helper"

RSpec.describe SprintsController, type: :controller do
  let!(:admin){Fabricate(:user, role: 2, email: "chu.anh.tuan@framgia.com",
    name: "Chu Anh Tuan")}
  let!(:user){Fabricate(:user, id: 2)}
  let!(:project){Fabricate(:project,id: 1, manager_id: admin.id)}
  let!(:product_backlog){Fabricate(:product_backlog, estimate: 16, actual: 4,
      remaining: 12, project_id: project.id)}
  let!(:sprint){Fabricate(:sprint, project_id: project.id)}
  before{sign_in admin}

  describe "GET #show" do
    before{get :show, project_id: 1, id: sprint.id}
    it {expect(response).to be_success}
    it {should render_template("show")}
  end

end

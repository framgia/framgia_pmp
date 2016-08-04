require "rails_helper"

RSpec.describe Admin::SprintsController, type: :controller do
  let!(:admin){Fabricate(:user, role: 2, email: "chu.anh.tuan@framgia.com",
    name: "Chu Anh Tuan")}
  let!(:user){Fabricate(:user, id: 2)}
  let!(:project){Fabricate(:project,id: 1, manager_id: admin.id)}
  let!(:product_backlog){Fabricate(:product_backlog, estimate: 16, actual: 4,
      remaining: 12, project_id: project.id)}
  let!(:sprint){Fabricate(:sprint, project_id: project.id)}
  before{sign_in admin}

  describe "Update success" do
    params = {name: "Sprint1",
      description: "Nihil ea est in rem.", project_id: "1",
      start_date: "04-07-2016", user_ids: ["","2"]}

    before {put :update, id: sprint.id, project_id: 1, sprint: params}
    it {should redirect_to(project_sprint_path)}
    it {should set_flash[:success]}
  end

  describe "Update false" do
    params = {name: "",
      description: "Nihil ea est in rem.", project_id: "1",
      start_date: "04-07-2016", user_ids: ["","2"]}

    before{put :update, id: sprint.id, project_id: 1, sprint: params}
    it {should render_template("edit")}
    it {should set_flash.now[:failed]}
  end

  describe "Create success" do
    params = {name: "Sprint1",
      description: "Nihil ea est in rem.", project_id: "1",
      start_date: "04-07-2016", user_ids: ["","2"]}

    before {post :create, project_id: 1, id: sprint.id, sprint: params}
    it {should set_flash[:success]}
    it {should redirect_to project_sprint_path(project, Sprint.last)}
  end

  describe "Create failed" do
    params = {name: "",
      description: "Nihil ea est in rem.", project_id: "1",
      start_date: "04-07-2016", user_ids: ["","2"]}

    before {post :create, project_id: 1, id: sprint.id, sprint: params}
    it {should render_template("new")}
    it {should set_flash.now[:failed]}
  end

  describe "Delete sprint" do
    before{delete :destroy, project_id: 1, id: sprint.id}
    it {should redirect_to admin_project_path(project)}
    it {should set_flash[:success]}
  end
end

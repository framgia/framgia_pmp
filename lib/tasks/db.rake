namespace :db do
  desc "Remaking data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke

    puts "Creating Manager"
    user = Fabricate :user, role: 2, email: "chu.anh.tuan@framgia.com",
      name: "Chu Anh Tuan"

    puts "Creating project"
    5.times do
      Fabricate :project, manager_id: user.id
    end

    puts "Creating product backlog"
    Project.all.each do |project|
      5.times do
        estimate = Faker::Number.between(4, 16)
        actual = Faker::Number.between(0, 4)
        remaining = estimate - actual
        
        Fabricate :product_backlog, estimate: estimate, actual: actual,
          remaining: remaining, project_id: project.id
      end
    end

    puts "Creating sprint"
    2.times do
      puts "Creating project"
      Fabricate :sprint, project_id: 1
    end

    puts "Creating member"
    user_hash = {
      "Nguyen Binh Dieu": "nguyen.binh.dieu",
      "Nguyen Thai Son": "nguyen.thai.son",
      "Vu Thi Ngoc": "vu.thi.ngoc",
      "Nguyen Hoang Nam": "nguyen.hoang.nam",
      "Nguyen Van Hien": "nguyen.van.hien",
      "Dao Duy Dat": "dao.duy.dat",
      "Nguyen Dac Truong": "nguyen.dac.truong",
    }

    user_hash.each do |key, value|
      user = Fabricate :user, name: key, email: value+"@framgia.com"
    end

    puts "Add asignee to sprints 1"
    User.all.each do |user|
      Fabricate :assignee, user_id: user.id, project_id: Project.first.id,
        sprint_id: Sprint.first.id
    end

    puts "Creating phase"
    ["Line of code", "Unit Test", "Integration Test"].each do |phase|
        Fabricate :phase, phase_name: phase
    end

    puts "Creating work performance data"
    Activity.all.each do |activity|
      Fabricate :work_performance, phase_id: Phase.first.id, activity_id: activity.id
    end

    puts "Success remake data"
    puts "Create activities for sprint 1"
    Sprint.first.assignees.each do |assignee|
      Fabricate :activity, user_id: assignee.id, sprint_id: Sprint.first.id
    end
  end
end

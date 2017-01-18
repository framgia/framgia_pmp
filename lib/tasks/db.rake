namespace :db do
  desc "Remaking data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke

    puts "Creating Manager"
    user = Fabricate :user, role: 0, email: "chu.anh.tuan@framgia.com",
      name: "Chu Anh Tuan"

    puts "Creating project"
    project = Fabricate :project

    puts "Creating sprint for each project"
    2.times do
      Fabricate :sprint, project_id: project.id
    end

    puts "Creating product backlog"
    5.times do
      Fabricate :product_backlog, project_id: project.id,
        sprint_id: Sprint.first.id
    end

    puts "Creating member"
    user_hash = {
      "Nguyen Binh Dieu": "nguyen.binh.dieu",
      "Hoang Thi Nhung": "hoang.thi.nhung",
      "Luu Thi Thom": "luu.thi.thom",
      "Bui Thi Phan": "bui.thi.phan",
      "Nguyen Thi Phuong B": "nguyen.thi.phuongb",
      "Bui Van Duong": "bui.van.duong"
    }
    user_hash.each do |key, value|
      user = Fabricate :user, name: key, email: value + "@framgia.com", role: 2
    end

    puts "Add member to project 1"
    User.all.each do |user|
      user.manager? ? role = 0 : role = 1

      Fabricate :project_member, user_name: user.name, user_id: user.id,
        project_id: project.id, role: role
    end

    puts "Add asignee to sprints 1"
    ProjectMember.all.each do |member|
      as = Fabricate :assignee, user_id: member.user_id, member_id: member.id,
        project_id: project.id, sprint_id: Sprint.first.id, work_hour: 8
      as.time_logs.each do |time_log|
        time_log.update_attributes lost_hour: 1
      end
    end

    puts "Creating phase"
    ["Design", "Coding", "Testing"].each do |phase|
      Fabricate :phase, phase_name: phase
    end

    puts "Chose phase for project"
    Fabricate :project_phase, project_id: project.id, phase_id: 2
    Fabricate :project_phase, project_id: project.id, phase_id: 3

    puts "Creating tasks for the first sprint of project 1"
    Sprint.first.assignees.each do |assignee|
      ac = Fabricate :task, user_id: assignee.user.id,
        sprint_id: Sprint.first.id, product_backlog_id: ProductBacklog.first.id
      start_log_work = 8
      ac.log_works.each do |log_work|
        log_work.update_attributes remaining_time: start_log_work
      end
    end

    puts "Creating item performances"
    Fabricate :item_performance, performance_name: 0, chart_type: 0
    Fabricate :item_performance, performance_name: 1, chart_type: 1
    Fabricate :item_performance, performance_name: 2, chart_type: 1
    Fabricate :item_performance, performance_name: 3, chart_type: 0
    Fabricate :item_performance, performance_name: 4, chart_type: nil
    Fabricate :item_performance, performance_name: 5, chart_type: nil

    puts "Add item performances to phase"
    ItemPerformance.all.each do |item|
      item_alias = if item.id == 6
       "Line of Code"
      else
        item.performance_name.humanize
      end

      Fabricate :phase_item, phase_id: 2, item_performance_id: item.id,
        visible: true, alias: item_alias
    end

    puts "Create work performances value"
    Task.all.each do |task|
      if task.user_id
        project.phases.each do |phase|
          Sprint.first.master_sprints.each do |day|
            performance_value = Random.rand(50..200)

            Fabricate :work_performance, phase_id: phase.id, sprint_id: 1,
              master_sprint_id: day.id, task_id: task.id,
              item_performance_id: 6, performance_value: performance_value
          end
        end
      end
    end

    puts "Success remake data"
  end
end

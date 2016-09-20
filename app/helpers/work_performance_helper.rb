module WorkPerformanceHelper
  def work_performance_of_team sprint
    arr = []
    items_of_sprint = sprint.work_performances.pluck(:phase_item_id).uniq
    items_of_sprint.each do |item|
      item_data = calculate_each_item_of_team_in_a_sprint(sprint, item)
      arr << item_data
    end
    return arr
  end

  private
  def user_work_performance sprint, phase_item_id, users
    name_item = PhaseItem.find_by(id: phase_item_id).name
    item_data = {name: name_item, data: []}

    sprint.master_sprints.order(:day).each do |day|
      item_value = WorkPerformance.data_of_an_item_in_a_day(day, phase_item_id, users)
        .sum(:performance_value)
      item_data[:data] << item_value
    end
    return item_data
  end

  def calculate_each_item_of_team_in_a_sprint sprint, phase_item_id
    @users_in_team = sprint.activities.pluck(:user_id)
    item_data = user_work_performance(sprint, phase_item_id, @users_in_team)
    item_data[:data].map! {|data| data /= (@users_in_team.size.nonzero? || 1)}
    return item_data
  end
end

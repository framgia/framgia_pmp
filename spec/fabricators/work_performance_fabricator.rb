Fabricator :work_performance do
  activity_id
  phase_item_id
  master_sprint_id
  sprint_id
  user_id
  performance_value {Faker::Number.between(1, 10)}
end

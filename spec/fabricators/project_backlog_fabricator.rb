Fabricator(:product_backlog) do
  priority 1
  project_id {sequence(:project_id, 1)}
  actual 0
  estimate 4
  remaining 4
  sprint_id 1
end

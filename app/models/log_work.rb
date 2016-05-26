class LogWork < ActiveRecord::Base
  belongs_to :activity
  default_scope {order(:day)}
end

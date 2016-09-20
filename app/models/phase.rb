class Phase < ActiveRecord::Base
  has_many :phase_items

  PHASE_ATTRIBUTES_PARAMS = [:phase_name, :description]

  validates :phase_name, uniqueness: true, presence: true
end

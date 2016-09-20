class PhaseItem < ActiveRecord::Base
  belongs_to :phase
  belongs_to :item_performance

  has_many :work_performances

  delegate :name, to: :item_performance
end

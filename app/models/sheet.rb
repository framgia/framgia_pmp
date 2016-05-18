class Sheet < ActiveRecord::Base
  has_many :headers
  has_many :triggers
  has_many :cells

  belongs_to :user
end

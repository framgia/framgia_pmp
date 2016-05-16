class User < ActiveRecord::Base
  has_many :assignees
  has_many :time_logs
  has_many :activities
  has_many :projects, foreign_key: :manager_id
  has_many :sprints, through: :assignees
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable

  USER_ATTRIBUTES_PARAMS = [:name, :email, :password, :password_confirmation]

  enum role: [:member, :leader, :manager]

  validates :name, presence: true, length: {maximum: 50}

  before_create :set_default_role

  private
  def set_default_role
    self.role ||= :member
  end
end

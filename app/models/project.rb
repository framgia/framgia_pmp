class Project < ActiveRecord::Base
  belongs_to :manager, class_name: User.name

  has_many :sprints
  has_many :product_backlogs
  has_many :assignees
  has_many :users, through: :members
  has_many :project_phases
  has_many :phases, through: :project_phases
  has_many :phase_items, through: :phases
  has_many :item_performances, through: :phase_items
  has_many :members, class_name: ProjectMember.name, foreign_key: :project_id

  ProjectMember.roles.each do |key, value|
    has_many :"#{key.pluralize}", ->{where role: value},
      class_name: ProjectMember.name
  end

  enum status: [:init, :in_progress, :close, :finish]

  after_create :create_product_backlog, :update_status

  DEFAULT_PRODUCT_BACKLOG = 10
  PROJECT_ATTRIBUTES_PARAMS = [:name, :description, :start_date,
    :end_date]

  validate :check_end_date, on: [:create, :update]

  delegate :name, to: :manager, prefix: true, allow_nil: true

  scope :is_not_closed, ->{where.not status: 2}

  def include_assignee? current_user
    self.members.map(&:user_id).include? current_user.id
  end

  def total_spent_time
    spent_time = self.sprints.map(&:total_spent_time)
    spent_time.reduce(0, :+)
  end

  def create_manager current_user
    self.members.create user: current_user, user_name: current_user.name,
      role: :manager
  end

  private
  def check_end_date
    if self.start_date.present? && self.end_date < self.start_date
      errors.add :end_date, I18n.t("errors.wrong_end_date")
    end
  end

  def update_status
    if self.start_date.present? && self.start_date < Date.today
      status = :in_progress
    else
      status = :init
    end
    self.update_attributes status: status
  end

  def create_product_backlog
    DEFAULT_PRODUCT_BACKLOG.times do
      ProductBacklog.create(project_id: self.id)
    end
  end
end

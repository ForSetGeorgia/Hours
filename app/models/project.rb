class Project < ActiveRecord::Base
  attr_accessible :id, :name, :organization_id, :active, :group_ids, :activities_attributes, :manager_id, :notes

  belongs_to :organization
  belongs_to :manager, class_name: 'User'
  has_and_belongs_to_many :groups
  has_many :activities, dependent: :destroy

  accepts_nested_attributes_for :activities, :reject_if => :all_blank, allow_destroy: true

  scope :is_active, where(active: true)
  scope :sorted, order('name asc')
  scope :sorted_organization, includes(:organization).order('organizations.short_name asc, projects.name asc')
  scope :with_activities, includes(:activities)
  scope :sorted_organization_activities, includes(:organization, :activities).order('organizations.short_name asc, projects.name asc, activities.name asc')
  def self.with_notes
    with_activities.where("projects.notes is not null OR activities.notes is not null")
  end

  validates :name, :organization_id, :presence => true

  def full_name
    "#{organization.short_name}: #{name}"
  end

  # return array of group names
  def group_names
    self.groups.map{|x| x.name}.sort
  end

  # return array of active group names
  def active_group_names
    self.groups.select{|x| x.active == true}.map{|x| x.name}.sort
  end

  # return array of activities
  def activity_names
    self.activities.select{|x| x.active == true}.map{|x| x.full_name}.sort
  end


  #############

  # # group the projects so that the projects the user has worked on during the last week
  # # are shown at the top of the list
  # # returns: user_projects, projects
  # def self.grouped_by_recent(user_id)
  #   projects = is_active.sorted_organization
  #   user_projects = nil

  #   project_ids = Timestamp.by_user(user_id).for_last_week.pluck(:project_id).uniq

  #   if project_ids.present?
  #     # pull out the users projects from the main list and insert on top
  #     user_projects = projects.select{|x| project_ids.include?(x.id)}
  #     projects.delete_if{|x| project_ids.include?(x.id)}
  #   end

  #   return user_projects, projects
  # end

end

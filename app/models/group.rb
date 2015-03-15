class Group < ActiveRecord::Base
  attr_accessible :active, :name, :project_ids

  has_and_belongs_to_many :projects

  validates :name, :active, :presence => true

  scope :is_active, where(active: true)
  scope :sorted, order('name asc')


  # return array of project names
  def project_names
    self.projects.map{|x| x.full_name}.sort
  end

  # return array of active project names
  def active_project_names
    self.projects.select{|x| x.active == true}.map{|x| x.full_name}.sort
  end

end

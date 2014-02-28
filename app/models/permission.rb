class Permission < ActiveRecord::Base
  attr_accessible :description, :model_name, :name
  has_and_belongs_to_many :roles
end

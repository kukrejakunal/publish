require 'ability'
class User < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name,:email, :password, :password_confirmation, :remember_me,:is_guest

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :roles
  has_many :articles
  SORTABLE_FIELDS = ["id","name","email"]

  ## Roles and permissions for user w.r.t Article Engine
  ROLE = {
      :ADMIN => "Admin",
      :EDITOR => "Editor",
      :REPORTER => "Reporter",
      :GUEST => "Guest"
  }

  PERMISSIONS = {
      :ARTICLE => {
          :CREATE => 'create_new_article',
          :EDIT => 'edit_any_article',
          :DELETE => 'delete_any_article',
          :PUBLISH => 'publish_article',
          :COMMENT => 'comment_on_article',
          :VIEW => "view_any_article",
          :COMPLETED => "view_completed_article"
      },
      :USER => {
          :UPDATE => "update_user_role"
      }
  }

  delegate :can?, :cannot?, :to => :ability

  def role_ids
    self.roles.collect(&:id)
  end

  def is_guest?
    is_guest
  end

  def ability
    current_ability =  Rails.cache.fetch("ability_#{self.id}", :expires_in => 30.minutes) do
      Marshal::dump Ability.new(self)
    end
    @ability = Marshal::load current_ability
    @ability
  end

  def can_view_completed_article?
    can? PERMISSIONS[:ARTICLE][:COMPLETED], :all
  end

  def can_update_role?
    can? PERMISSIONS[:USER][:UPDATE], :all
  end

  def can_delete_article?(article_user_id)
    article_user_id == self.id && can?(PERMISSIONS[:ARTICLE][:DELETE], :ARTICLE)
  end

  def can_edit_article?(article_user_id)
    article_user_id == self.id && can?(PERMISSIONS[:ARTICLE][:EDIT], :ARTICLE)
  end

  def can_publish_article?
    can?(PERMISSIONS[:ARTICLE][:PUBLISH], :ARTICLE)
  end

  def can_add_article?
    can?(PERMISSIONS[:ARTICLE][:CREATE], :ARTICLE)
  end

  def self.search_user_name(scope,name)
    conditions = "lower(users.name) like lower(:name) OR " +
        "lower(users.email) like lower(:name)"
    scope = scope.where(conditions, :name => "%#{name.split(" ").join("%")}%")
    scope
  end

  # method to send email notification to new user with passowrd
  def send_new_user_notifications
    generate_reset_password_token! if reset_password_token.nil? || !reset_password_period_valid?
    Devise::CustomMailer.new_user_notifications(self).deliver
  end

end

class Article < ActiveRecord::Base

  attr_accessible :body, :status, :title, :user

  belongs_to :user

  before_create :default_values

  validates_presence_of :title,:body,:status,:user

  STATE = {:draft=> "DRAFT", :complete => "COMPLETE", :publish => "PUBLISH"}

  scope :allowed, lambda{|user|
    condition = []
    condition << "status = '#{STATE[:publish]}'"
    condition << "user_id = #{user.id}" unless user.blank?
    condition << "status = '#{STATE[:complete]}' " if user && user.can_view_completed_article?
    where(condition.join(" OR "))
  }

  def is_publishable?
    status == STATE[:complete]
  end

  def is_in_draft?
    status == STATE[:draft]
  end


  def default_values
    self.status ||= STATE[:draft]
  end


end


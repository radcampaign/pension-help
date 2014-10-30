# == Schema Information
# Schema version: 41
#
# Table name: feedbacks
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)
#  email        :string(255)
#  phone        :string(255)
#  availability :string(255)
#  category     :string(255)
#  feedback     :text
#  is_resolved  :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#
require "email"

class Feedback < ActiveRecord::Base
  acts_as_commentable

  #returns hashs of parameters for paginate function
  def Feedback.get_parameters_for_pagination params
    order = (SORT_ORDER[params[:order]] ? SORT_ORDER[params[:order]] : SORT_ORDER['name'])
    order << ' DESC' if params[:desc]

    select = " id, name, category, SUBSTRING(feedback, 1, 100) AS 'feedback', is_resolved, updated_at "

    return {:conditions => prepare_condition(params),:select => select, :order =>order}
  end

  #list of concern issues
  def Feedback.get_categories
    @@CATEGORIES
  end

  #add a new comment to feedback
  def add_comment(c, user)
    unless c.nil?
      comment = Comment.new
      comment.comment = c
      comment.user = user
      comments << comment
    end
  end

  validates_presence_of :category, :message => "^Feedback concern can't be blank"
  validates_presence_of :feedback
  validate :validate_email

  private

  #prepare search condition for listing feedbacks
  def Feedback.prepare_condition params
    sql_cond = Array.new
    sql_param = Array.new

    if params[:resolved] && params[:resolved] != 'a'
      sql_cond << 'feedbacks.is_resolved = ?'
      sql_param << params[:resolved]
    end

    if params[:category]
      sql_cond << 'feedbacks.category = ?'
      sql_param << (@@CATEGORIES.include?(params[:category]) ? params[:category] : '')
    end

    cond = nil
    unless sql_cond.empty?
      cond = [sql_cond.join(' AND ')]
      cond.concat(sql_param)
    end

    return cond
  end

  #sort param mappings
  SORT_ORDER = {
    'name' => 'feedbacks.name',
    'category' => 'feedbacks.category',
    'resolved' => 'feedbacks.is_resolved',
    'updated' => 'feedbacks.updated_at'
  }

  @@CATEGORIES = [
    "Broken Link(s)",
    "Information on this website",
    "Information on a website we link to",
    "Service Provider Referral",
    "General Feedback"
  ]


  protected

  def validate_email
    if email.blank?
      self.errors.add(:email, "can't be blank")
    elsif email !~ EMAIL_REGEX
      self.errors.add(:email, "is invalid")
    end
  end
end

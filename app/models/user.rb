# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  login                     :string(255)
#  email                     :string(255)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  is_random_pass            :boolean
#  encrypted_password        :string(255)      default(""), not null
#  reset_password_token      :string(255)
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string(255)
#  last_sign_in_ip           :string(255)
#  confirmation_token        :string(255)
#  confirmed_at              :datetime
#  confirmation_sent_at      :datetime
#  unconfirmed_email         :string(255)
#

require 'digest/sha1'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable , :authentication_keys => [:login]

  has_and_belongs_to_many :roles
  has_one :partner

  # Setup accessible (or protected) attributes for your model

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false

  #Permissions
  def can_manage_site?
    has_relevant_roles([ADMIN_ROLE])
  end

  def is_admin?
    has_relevant_roles([ADMIN_ROLE])
  end

  #Only admins can do that.
  def can_manage_partners?
    has_relevant_roles([ADMIN_ROLE])
  end

  protected

  #Checks if user has given roles
  def has_relevant_roles(array_of_proper_roles)
    is_relevant = false

    for role in self.roles
      is_relevant = array_of_proper_roles.include?(role.role_name)

      if(is_relevant == true)
        break
      end
    end
    return is_relevant
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
     where(conditions).where(["lower(login) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
     where(conditions).first
    end
  end
end

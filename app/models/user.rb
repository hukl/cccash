require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  has_one :workshift

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :admin

  named_scope :admins,  :conditions => { :admin => true }
  named_scope :angels,  :conditions => { :admin => false }
  named_scope(
    :busy,
    :joins => :workshift,
    :conditions => ["workshifts.user_id = users.id AND workshifts.cleared = false"]
  )

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def angel?
    !admin?
  end
  
  def destroy
    if 0 < Workshift.find_all_by_user_id(id).count
      errors.add(:workshifts, "Can't delete User with workshift(s)")
      return false
    else
      super
    end
  end
  
  def active_workshift
    Workshift.find(:first, :conditions => {:active => true, :user_id => id})
  end
  
end
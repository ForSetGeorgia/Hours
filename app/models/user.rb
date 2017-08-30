class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
	# :registerable, :recoverable,
  devise :database_authenticatable,:registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role,
                  :provider, :uid, :nickname, :avatar
  attr_accessor :send_notification

  has_many :timestamps, dependent: :destroy
  has_many :projects, foreign_key: :manager_id, dependent: :nullify

  validates :role, :presence => true

  ROLES = {:user => 0, :staff => 1, :site_admin => 75, :admin => 99}

  def others
    User.where('role >= ? and id != ?', ROLES[:staff], self.id)
      .order('email asc, nickname asc')
  end

  def others_list
    others
      .map{|m| [m.nickname.capitalize, m.id]}
      .unshift([I18n.t('app.common.all'), 0])
  end

  def self.no_admins
    where("role != ?", ROLES[:admin])
  end

	# if no role is supplied, default to the basic user role
	def check_for_role
		self.role = ROLES[:user] if self.role.nil?
	end

  # use role inheritence
  # - a role with a larger number can do everything that smaller numbers can do
  def role?(base_role)
    if base_role && ROLES.values.index(base_role)
      return base_role <= self.role
    end
    return false
  end

  def can_manage?
    role?(ROLES[:site_admin])
  end

  def role_name
    ROLES.keys[ROLES.values.index(self.role)].to_s
  end

  def nickname
    n = read_attribute(:nickname)
    n.present? ? n : self.email.split('@')[0].capitalize
  end


  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(  nickname: auth.info.nickname,
                           provider: auth.provider,
                           uid: auth.uid,
                           email: auth.info.email.present? ? auth.info.email : "<%= Devise.friendly_token[0,10] %>@fake.com",
                           avatar: auth.info.image,
                           password: Devise.friendly_token[0,20]
                           )
    end
    user
  end

  # if login fails with omniauth, sessions values are populated with
  # any data that is returned from omniauth
  # this helps load them into the new user registration url
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

	# if user logged in with omniauth, password is not required
	def password_required?
		super && provider.blank?
	end


  #############################
  def self.sorted
    order('email asc')
  end

  def self.managers
    where('role >= ?', ROLES[:site_admin])
  end

  def self.staff
    where('role >= ?', ROLES[:staff])
  end

  def self.needs_notifications
    user_ids = Timestamp.has_records_today
    if user_ids.present?
      staff.where(["id not in (?)", user_ids])
    else
      staff
    end
  end

end

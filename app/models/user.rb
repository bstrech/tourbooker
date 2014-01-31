class User < ActiveRecord::Base
  include AASM
  strip_attributes
  attr_accessible :amn_doctor, :amn_movie_theater, :amn_pool, :amn_rec_room, :amn_time_machine, :email, :first_name, :ip_address, :last_name, :phone, :preferred_tour_date, :rating, :token
  before_validation :downcase_email
  after_initialize :generate_token
  validates :email, presence: true, uniqueness: true, format: $EMAIL_FORMAT
  validates :token, presence: true
  validates :first_name, presence: {:unless=>:new?}
  validates :last_name, presence: {:unless=>:new?}
  validates :phone, presence: {:unless=>:new?}
  validates :preferred_tour_date, presence: {:if=>:past_step_2}
  validates :ip_address, presence: {:if=>:past_step_2}
  validates :rating, presence: true, inclusion: { in: 1..5 }, :if=>:done?
  aasm do
    state :new, :initial => true
    state :validating
    state :registering
    state :registered
    state :done

    event :validate do
      transitions :from => :new, :to => :validating
    end
    event :register do
      transitions :from => :validating, :to => :registering
    end
    event :submit do
      transitions :from => :registering, :to => :registered
    end
    event :finish do
      transitions :from => :registered, :to => :done
    end
  end

  private
  def downcase_email
    self.email.downcase! if email
  end
  def generate_token
    self.token = SecureRandom.base64(15).tr('+/=', 'xyz')
  end
  def past_step_2
    states = []
    self.aasm.states.each_with_index do |state, i|
      states << state.name.to_s if i>1
    end
    states.include?(self.aasm_state)
  end

end

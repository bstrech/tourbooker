class User < ActiveRecord::Base
  include AASM
  strip_attributes
  attr_accessible :amn_doctor, :amn_movie_theater, :amn_pool, :amn_rec_room, :amn_time_machine, :email, :first_name, :last_name, :phone, :preferred_tour_date, :rating, :token, :aasm_state, :ip_address
  before_validation :downcase_email
  after_initialize :generate_token
  after_create :send_create_email
  after_save :check_user_is_done
  validates :email, presence: true, uniqueness: true, format: $EMAIL_FORMAT
  validates :token, presence: true
  validates :first_name, presence: {:unless=>:new?}
  validates :last_name, presence: {:unless=>:new?}
  validates :phone, presence: {:unless=>:new?}
  validates :preferred_tour_date, presence: {:if=>:past_step_2}
  validates :ip_address, presence: {:if=>:past_step_2}
  validates :rating, inclusion: { in: 1..5, allow_nil: true }
  aasm do
    state :new, :initial => true
    state :activating
    state :registering
    state :done

    event :activate do
      transitions :from => :new, :to => :activating
    end
    event :register do
      transitions :from => :activating, :to => :registering
    end
    event :finish do
      transitions :from => :registering, :to => :done
    end
  end

  def send_create_email
    UserMailer.create_user(self).deliver if !self.new_record?
  end

  def send_tour_scheduled
    UserMailer.tour_scheduled_confirmation(self).deliver if self.done?
  end

  def send_new_tour_scheduled
    UserMailer.new_tour_scheduled(self).deliver if self.done?
  end

  private
  def downcase_email
    self.email.downcase! if email
  end

  def  check_user_is_done
    if self.aasm_state_changed? && self.done?
      self.send_tour_scheduled
      self.send_new_tour_scheduled
    end
  end

  def generate_token
    self.token = SecureRandom.base64(15).tr('+/=', 'xyz')  if self.token.blank?
  end
  def past_step_2
    states = []
    self.aasm.states.each_with_index do |state, i|
      states << state.name.to_s if i>1
    end
    states.include?(self.aasm_state)
  end

end

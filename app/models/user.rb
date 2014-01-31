class User < ActiveRecord::Base
  include AASM
  strip_attributes
  attr_accessible :amn_doctor, :amn_movie_theater, :amn_pool, :amn_rec_room, :amn_time_machine, :email, :first_name, :ip_address, :last_name, :phone, :preferred_tour_date, :rating, :token
  before_validation :downcase_email
  validates :email, presence: true, uniqueness: true, format: $EMAIL_FORMAT
  aasm do
    state :new, :initial => true
    state :validating
    state :registering
    state :rating
    state :done

    event :validate do
      transitions :from => :new, :to => :registering
    end
    event :register do
      transitions :from => :registering, :to => :rating
    end
    event :rate do
      transitions :from => :rating, :to => :done
    end
  end

  private
  def downcase_email
    self.email.downcase! if email
  end
end

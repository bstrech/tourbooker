class User < ActiveRecord::Base
  strip_attributes
  attr_accessible :amn_doctor, :amn_movie_theater, :amn_pool, :amn_rec_room, :amn_time_machine, :email, :first_name, :ip_address, :last_name, :phone, :preferred_tour_date, :rating, :token
  before_validation :downcase_email
  validates :email, presence: true, uniqueness: true, format: $EMAIL_FORMAT


  private
  def downcase_email
    self.email.downcase! if email
  end
  def check_email_format
    errors.add(:email, I18n.t('activerecord.errors.models.user.attributes.email.invalid')) unless $EMAIL_FORMAT.match(self.email)
  end
end

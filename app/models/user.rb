class User < ActiveRecord::Base
  strip_attributes
  attr_accessible :amn_doctor, :amn_movie_theater, :amn_pool, :amn_rec_room, :amn_time_machine, :email, :first_name, :ip_address, :last_name, :phone, :preferred_tour_date, :rating, :token
  validates :email, :presence=>true
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :token
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :ip_address
      t.date :preferred_tour_date
      t.boolean :amn_pool
      t.boolean :amn_rec_room
      t.boolean :amn_movie_theater
      t.boolean :amn_doctor
      t.boolean :amn_time_machine
      t.integer :rating
      t.string :aasm_state, :default => 'new'
      t.timestamps
    end
    add_index :users, :email
  end
end

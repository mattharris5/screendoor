class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :uid
      t.string :name
      t.string :status
      t.boolean :welcome_sent
      t.boolean :cleaning_scheduled

      t.timestamps
    end
  end
end

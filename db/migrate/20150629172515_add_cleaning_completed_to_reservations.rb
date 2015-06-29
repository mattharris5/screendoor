class AddCleaningCompletedToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :cleaning_completed, :boolean
  end
end

class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
  end
end

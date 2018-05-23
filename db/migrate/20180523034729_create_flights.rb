class CreateFlights < ActiveRecord::Migration[5.0]
  def change
    create_table :flights do |t|
      t.string :source
      t.string :destination

      t.timestamps
    end
  end
end

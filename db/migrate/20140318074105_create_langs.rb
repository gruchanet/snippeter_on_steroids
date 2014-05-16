class CreateLangs < ActiveRecord::Migration
  def change
    create_table :langs do |t|
      t.string :name
      t.string :value
      t.integer :order_type

      t.timestamps
    end
  end
end

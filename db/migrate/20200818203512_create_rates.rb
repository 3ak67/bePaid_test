class CreateRates < ActiveRecord::Migration[5.2]
  def change
    create_table :rates do |t|
      t.belongs_to :post
      t.integer :value, null: false

      t.timestamps
    end
  end
end

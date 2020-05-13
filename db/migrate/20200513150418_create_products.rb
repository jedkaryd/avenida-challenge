class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.integer :stock, null: false
      t.float :price, null: false
      t.string :state, null: false, default: 'visible'

      t.timestamps
    end
  end
end

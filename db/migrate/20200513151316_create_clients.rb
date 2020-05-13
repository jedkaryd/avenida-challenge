class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.integer :dni, null: false
      t.string :phone_number
      t.text :address

      t.timestamps
    end
  end
end

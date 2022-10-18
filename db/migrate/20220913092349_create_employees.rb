class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :last_name
      t.string :email
      t.string :address
      t.string :designation
      t.string :city
      t.string :mob_no
      t.integer :salary
      t.string :technology
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end

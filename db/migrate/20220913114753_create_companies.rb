class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :phone_no
      t.string :pin_code
      t.string :technologies
      t.string :link
      t.string :linkdin
      t.string :instagram
      t.string :facebook
      
      t.timestamps
    end
  end
end

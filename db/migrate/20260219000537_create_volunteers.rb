class CreateVolunteers < ActiveRecord::Migration[8.0]
  def change
    create_table :volunteers do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :phone_number
      t.string :address
      t.text :skills

      t.timestamps
    end

    add_index :volunteers, :username, unique: true
    add_index :volunteers, :email, unique: true
  end
end

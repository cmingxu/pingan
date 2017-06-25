class CreatePatients < ActiveRecord::Migration[5.0]
  def change
    create_table :patients do |t|
      t.integer :account_id
      t.string :name
      t.string :phone
      t.integer :age
      t.integer :month
      t.string :gender

      t.datetime :entroll_at

      t.timestamps
    end
  end
end

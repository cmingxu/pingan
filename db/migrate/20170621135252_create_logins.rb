class CreateLogins < ActiveRecord::Migration[5.0]
  def change
    create_table :logins do |t|
      t.string :ip
      t.integer :account_id
      t.string :status
      t.datetime :login_at
      t.text :exception
      t.string :proxy

      t.timestamps
    end
  end
end

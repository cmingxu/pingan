class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :username
      t.string :password
      t.string :user_agent
      t.string :proxy
      t.datetime :proxy_renew_at
      t.datetime :proxy_last_ok_at

      t.timestamps
    end
  end
end

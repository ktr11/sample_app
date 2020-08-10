class AddEmailTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email_token, :string
  end
end

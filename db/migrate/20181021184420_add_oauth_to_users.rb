class AddOauthToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :oauth, :string
  end
end

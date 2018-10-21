class AddConfirmedToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :confirmed, :boolean
  end
end

class SetActiveDefaults < ActiveRecord::Migration[5.2]
  def self.up
    change_column :users, :active, :boolean, :default => true
    change_column :breweries, :active, :boolean, :default => true
  end

  def self.down
    # You can't currently remove default values in Rails
    raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end
end

class RemoveStateFromEvents < ActiveRecord::Migration
  def change
  	remove_column :events, :state
  end
end

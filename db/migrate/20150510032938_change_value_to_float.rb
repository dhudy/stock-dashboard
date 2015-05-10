class ChangeValueToFloat < ActiveRecord::Migration
  def change
  	change_column :transactions, :value, :float
  end
end

class AddValueToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :value, :decimal
  end
end

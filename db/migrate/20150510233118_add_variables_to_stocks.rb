class AddVariablesToStocks < ActiveRecord::Migration
  def change
  	add_column :stocks, :high, :decimal
  	add_column :stocks, :low, :decimal
  	add_column :stocks, :open, :decimal
  end
end

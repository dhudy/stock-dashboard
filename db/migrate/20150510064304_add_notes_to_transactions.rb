class AddNotesToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :notes, :text
  end
end

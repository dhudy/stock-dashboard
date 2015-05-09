class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.integer :amount

      t.timestamps
    end
  end
end

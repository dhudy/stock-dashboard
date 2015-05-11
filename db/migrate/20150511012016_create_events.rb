class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :state
      t.datetime :end
      t.references :user, index: true

      t.timestamps
    end
  end
end

class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :hate
      t.integer :sympathy

      t.timestamps
    end
  end
end

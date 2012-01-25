class CreateSympathies < ActiveRecord::Migration
  def change
    create_table :sympathies do |t|
      t.integer :hate_id

      t.timestamps
    end
  end
end

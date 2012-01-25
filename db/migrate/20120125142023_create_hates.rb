class CreateHates < ActiveRecord::Migration
  def change
    create_table :hates do |t|
      t.string :twitter_id
      t.string :hate

      t.timestamps
    end
  end
end

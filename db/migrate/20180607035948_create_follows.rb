class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :participants
      t.integer :bet

      t.timestamps

    end
  end
end

class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.datetime :date_opened
      t.datetime :date_closed
      t.boolean :opened
      t.integer :item_id

      t.timestamps
    end
  end
end

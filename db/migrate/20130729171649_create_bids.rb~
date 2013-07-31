class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.datetime :offer_date
      t.decimal :value
      t.boolean :withraw, default:false
      t.integer :auction_id
      t.integer :user_id

      t.timestamps
    end
  end
end

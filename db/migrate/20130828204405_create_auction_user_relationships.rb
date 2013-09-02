class CreateAuctionUserRelationships < ActiveRecord::Migration
  def change
    create_table :auction_user_relationships do |t|
      t.integer :auction_id
      t.integer :listener_id

      t.timestamps
    end
    
    add_index :auction_user_relationships, :auction_id
    add_index :auction_user_relationships, :listener_id
    add_index :auction_user_relationships, [:auction_id, :listener_id], unique: true
    
  end
end

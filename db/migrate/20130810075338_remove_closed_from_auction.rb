class RemoveClosedFromAuction < ActiveRecord::Migration
  def up
    remove_column :auctions, :closed
  end

  def down
    add_column :auctions, :closed, :boolean
  end
end

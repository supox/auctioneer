class RemoveOpenedFromAuction < ActiveRecord::Migration
  def up
    remove_column :auctions, :opened
  end

  def down
    add_column :auctions, :opened, :boolean
  end
end

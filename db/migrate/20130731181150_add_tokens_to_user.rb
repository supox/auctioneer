class AddTokensToUser < ActiveRecord::Migration
  def change
      add_column :users, :reset_password_token, :string
      add_column :users, :reset_password_sent_at, :datetime
      add_column :users, :remember_token, :string
  end
end

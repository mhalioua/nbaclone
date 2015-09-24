class AddRestToLineups < ActiveRecord::Migration
  def change
  	add_column :lineups, :rest, :integer
  end
end

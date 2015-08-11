class AddWeekendBoolean < ActiveRecord::Migration
  def change
  	add_column(:games, :weekend, :boolean)
  	add_column(:games, :away_travel, :integer)
  	add_column(:games, :home_travel, :integer)
  end
end

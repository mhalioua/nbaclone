class AddWeekendToLineup < ActiveRecord::Migration
  def change
  	add_column :lineups, :weekend, :boolean
  end
end

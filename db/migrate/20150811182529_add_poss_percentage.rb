class AddPossPercentage < ActiveRecord::Migration
  def change

  	add_column(:starters, :poss_percent, :float)

  end
end

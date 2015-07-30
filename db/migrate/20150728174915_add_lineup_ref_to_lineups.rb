class AddLineupRefToLineups < ActiveRecord::Migration
  def change
    add_reference :lineups, :opponent, index: true
  end
end

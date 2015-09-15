class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|

    	t.references :season
    	t.integer :quarter
    	t.string :time
    	t.float :win_percent
    	t.integer :total_bet

      t.timestamps
    end
  end
end

class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
    	t.string "year"
      t.timestamps
    end
  end
end

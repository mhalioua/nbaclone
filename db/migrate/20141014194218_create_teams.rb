class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
    	t.string "name"
      t.string "abbr"
      t.string "city"
      t.float "latitude"
      t.float "longitude"
      t.timestamps
    end
    add_index("teams", "name")
    add_index("teams", "abbr")
    add_index("teams", "city")
  end
end
class AddPosition < ActiveRecord::Migration
  
  def up
  	add_column("starters", "position", :string)
  end

  def down
  	remove_column("starters", "position")
  end

end

class IndexController < ApplicationController
  def date
  	@players = Player.all
  	PlayerMatchup.where('player_one_id=? OR player_two_id=?', 1, 1)
  end

  def team
  end
end

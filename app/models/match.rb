class Match < ActiveRecord::Base
  belongs_to :player_x, class_name: 'User'
  belongs_to :player_o, class_name: 'User'
  has_many :moves
  # validate :match_won
  
  


  def free_square?(square_id,available_squares)
    available_squares.include?square_id
  end

  def assign_value(user)
    if user == player_x
      'x'
    else
      'o'
    end
  end
        
def move_for_square(square_id)
  moves.find_by(square_id: square_id)
end




  def self.new_match(player_x,player_o)
    Match.create(player_x_id: player_x.id, player_o_id: player_o.id)
  end

  def starting_board
    [1,2,3,4,5,6,7,8,9]
  end


  def total_played_squares
    moves.collect {|move| move.square_id}
  end

  def available_squares
    self.starting_board - total_played_squares
  end


  # def free_square?(square_id)
  #   available_squares.include?square_id
  # end

  def any_board_space?(available_squares)
    available_squares.any?
  end

  def whose_turn
    if moves.last.try(:user) == player_x
      player_o
    else
      player_x
    end
  end

  

  def add_move(user_id, square_id)
    Move.create!(user_id: user_id, square_id: square_id)
    # if my_turn?(user_id)
    #   moves.create!(user_id: user_id, square_id: square_id)
    # else
    #   puts "square is not available, or it's not your turn"

    # end
  end


  def get_player_combo(user_id)
    moves.map {|move| move.square_id if move.user_id==user_id}.compact
  end

  def set_winner(user_id)
    self.update(winner_id: user_id)
    self.save
  end

  def set_loser(user_id)
    self.update(loser_id: user_id)
    self.save
  end

  



  def set_match_status
    if moves.count < 9 && self.winner_id.nil?
      self.update(status: 'active')
    elsif winner_id
      self.update(status: 'won')
    elsif moves.count == 9 && self.winner_id.nil?
      self.update(status: 'draw')
    else
      self.update(status: 'draw')
    end
  end


  WIN_LINES = [[1,2,3],[1,4,7],[1,5,9],[2,5,8],[3,5,7],[3,6,9],[4,5,6],[7,8,9]]


  def match_won(player_x_id, player_o_id)
    WIN_LINES.each do |combo|
      if (get_player_combo(player_x_id) & combo).sort == combo.sort
        set_winner(player_x_id)
        set_loser(player_o_id)
        set_match_status
      elsif (get_player_combo(player_o_id) & combo).sort == combo.sort
        set_winner(player_o_id)
        set_loser(player_x_id)
        set_match_status
      else
        set_match_status
      end
    end
  end

  def drawn_matches(user_id)
    player_x_matches = Match.where(player_x_id: user.id)
    x_total = player_x_matches.where(status: 'draw').count
    player_o_matches = Match.where(player_o_id: user.id)
    o_total = player_o_matches.where(status: 'draw').count
  end




end

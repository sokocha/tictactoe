class Match < ActiveRecord::Base
  belongs_to :player_x, class_name: 'User'
  belongs_to :player_o, class_name: 'User'
  has_many :moves
  # after_create :winning_combo? 
  


  def free_square?(square_id,available_squares)
    available_squares.include?square_id
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

  def is_match_active?
    moves.count < 9 && self.winner_id.nil?
  end





  def add_move(user_id, square_id)
    moves.create!(user_id: user_id, square_id: square_id)
    # if my_turn?(user_id)
    #   moves.create!(user_id: user_id, square_id: square_id)
    # else
    #   puts "square is not available, or it's not your turn"

    # end
  end

  # def user_played_squares(user)
  #   user.moves.map {|move| move.square_id}.uniq
  #   # m.user_played_squares(s)
  # end

  def get_player_combo(user_id)
    moves.map {|move| move.square_id if move.user_id==user_id}.compact
  end



  WIN_LINES = [[1,2,3],[1,4,7],[1,5,9],[2,5,8],[3,5,7],[3,6,9],[4,5,6],[7,8,9]]

  def match_won
    WIN_LINES.each do |combo|
      if (get_player_combo(player_x_id) & combo).sort == combo.sort
        set_winner(player_x_id)
      elsif (get_player_combo(player_o_id) & combo).sort == combo.sort
        set_winner(player_o_id)
      end
    end
  end

  def set_winner(user_id)
    self.winner_id=user_id
    save
  end

    





end

class Match < ActiveRecord::Base
  belongs_to :player_x, class_name: 'User'
  belongs_to :player_o, class_name: 'User'
  has_many :moves
  # validate :match_won
  
  
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


  def free_square?(square_id)
    self.available_squares.include?square_id
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
    @move = Move.new(user_id: user_id, square_id: square_id, value: @match.assign_value(user_id))
    @move.save
  end


    # if my_turn?(user_id)
    #   moves.create!(user_id: user_id, square_id: square_id)
    # else
    #   puts "square is not available, or it's not your turn"

    # end


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


    # EDGE = [2,4,6,8]

    # CORNER = [1,3,7,9]

    # CENTER = [5]

    # TRIANGLE_CENTER = [[1,5,3],[1,5,7],[5,7,9],[3,5,9]]

    # TRIANGLE_RIGHT = [[1,3,7],[1,3,9],[1,7,9],[3,9,7]]

    # def shuffler(array,value)
    #   array.shuffle.pop(value)
    # end


#  EDGE
# a) play center 5 for user.id of 59


# def first_move
#   Move.create(match_id: self.id, user_id: whose_turn.id, square_id: 5, value: 'x')
# end

# def test_move(square_id)
#   Move.create(match_id: self.id, user_id: whose_turn.id, square_id: square_id, value: 'o')
# end

# def opp_plays_edge
#   if total_played_squares.include?2
#     Move.create(match_id: self.id, user_id: whose_turn.id, square_id: shuffler([7,9],1).join(",").to_i, value: 'x')
#   elsif total_played_squares.include?4
#     Move.create(match_id: self.id, user_id: whose_turn.id, square_id: shuffler([3,9],1).join(",").to_i, value: 'x')
#   elsif total_played_squares.include?6
#     Move.create(match_id: self.id, user_id: whose_turn.id, square_id: shuffler([1,7],1).join(",").to_i, value: 'x')
#   elsif total_played_squares.include?8
#     Move.create(match_id: self.id, user_id: whose_turn.id, square_id: shuffler([1,3],1).join(",").to_i, value: 'x')
#   end
# end


# c) complete TRIANGLE_CENTER
# get_player_combo(59)

# def comp_squares
#   self.get_player_combo(player_x_id)
# end


# and use it to iterate through TRIANGLE_CENTER. 

# TRIANGLE_CENTER.collect do |sub_array|
#   sub_array & match.comp_squares
# end
# a = _
# victory = a.collect {|array| array.count}

# index of everywhere in array where comp has 2 of 3 of triangle center
# index_positions = (victory.each_index.select {|i| victory[i] == 2}).join(',').to_i


# remaining square to play to complete triangle (as array)
# def triangle_completion
#   (TRIANGLE_CENTER[index_positions] - match.comp_squares).join(',').to_i
# end



# completes the triangle with a move
# def third_move
#   Move.create(match_id: self.id, user_id: whose_turn.id, square_id: triangle_completion, value: 'x')
# end

# Now I need to set up if statements of where to play the 4th and final move based on opp's move. So far in example comp played 5,7,9. Opp played 1,2 so far.

# def fourth_move
#   while match.status == 'active' && match.whose_turn == player_x
#     if total_played_squares.include?8
#       Move.create(match_id: match.id, user_id: match.whose_turn.id, square_id: 3, value: 'x')
#     elsif total_played_squares.include?3
#       Move.create(match_id: match.id, user_id: match.whose_turn.id, square_id: 8, value: 'x')
#     else
#       Move.create(match_id: match.id, user_id: match.whose_turn.id, square_id: 3, value: 'x')
#     end
#   end
# end


# Find where the intersection count is 2
# then play the remaining square by subtracting the player_combo from the given TRIANGLE_CENTER.



# d) win

# CORNER1
# a) play center 5
# b) if opp plays 1, play 9
#    if opp plays 3, play 7
#    if opp plays 7, play 3
#    if opp plays 9, play 1
# c) if opp plays edge, block
# d) win 

# CORNER2
# a) play center 5
# b) if opp plays 1, play 9
#    if opp plays 3, play 7
#    if opp plays 7, play 3
#    if opp plays 9, play 1
# c) if opp plays corner, block
# d) if can win, win else block, else random (while winner_id is nil and moves.count<9)

# BLOCK


# WIN





end

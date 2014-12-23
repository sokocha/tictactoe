class Move < ActiveRecord::Base
  belongs_to :match
  belongs_to :user
  validate :if_match_active, on: :create
  validate :is_users_turn
  validate :is_within_range?
  validate :match_winner, on: :create

  def if_match_active
    errors.add(:base, 'This match is no longer active') if !match.is_match_active?
  end

  # def check_win
  #   match.match_won
  # end

  def match_winner
    errors.add(:base, 'There is a winner. Start a new game') if match.winner_id != nil
  end

  

  def is_users_turn
    errors.add(:base, "It is not your turn") if match.whose_turn.id != user.id
  end



  def is_within_range?
      errors.add(:base, "The index is not in range") unless match.starting_board.include?(square_id)
  end







end

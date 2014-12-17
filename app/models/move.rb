class Move < ActiveRecord::Base
  belongs_to :match
  belongs_to :user
  validate :if_match_active, on: :create
  validate :is_users_turn
  validate :is_within_range?

  after_create :check_win

  def if_match_active
    errors.add(:match_id, 'not active') if !match.is_match_active?
  end

  def check_win
    match.match_won
  end



  def is_users_turn
    errors.add(:base, "Is not this user's turn") if match.whose_turn.id != user.id
  end

  def is_within_range?
      errors.add(:base, "The index is not in range") unless match.starting_board.include?(square_id)
  end







end

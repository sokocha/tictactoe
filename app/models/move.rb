class Move < ActiveRecord::Base
  belongs_to :match
  belongs_to :user
 
  validate :match_winner, on: :create
  validate :is_users_turn

  



  def match_winner
    errors.add(:base, 'There is a winner. Start a new game') if match.winner_id != nil
  end

  def is_users_turn
    errors.add(:base, "It is not your turn") if match.whose_turn.id != user.id
  end







end

class MatchesController < ApplicationController
  
  before_action :set_match, only: [:show, :edit, :update, :destroy, :move]

  respond_to :html

  def index
    # @matches = Match.all
    # @matches = Match.where player_x: current_user.id
    @matches = Match.where("player_x_id = ? or player_o_id = ?", current_user.id, current_user.id)
  end

  def show
    respond_with(@match)
  end

  def new
    @match = Match.new
    @users = User.order('name ASC') - [current_user]
    respond_with(@match)
  end

  def edit
  end

  def move
    @move = Move.new(match_id: @match.id, user_id: current_user.id, square_id: params[:square_id], value: @match.assign_value(current_user))
    if @move.save
      redirect_to @match
    else
      render :show
    end
  end

  def create
    @match = Match.new(match_params)
    @match.player_x = current_user
    @users = User.order('name ASC') - [current_user]
    @match.save
    respond_with(@match)
  end

  def update
    @match.update(match_params)
    respond_with(@match)
  end

  def destroy
    @match.destroy
    respond_with(@match)
  end

  private
  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:player_x_id, :player_o_id)
  end
end

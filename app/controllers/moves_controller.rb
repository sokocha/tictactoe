class MovesController < ApplicationController
  before_action :set_move, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @moves = Move.all
    respond_with(@moves)
  end

  def show
    respond_with(@move)
  end

  def new
    @move = Move.new
    respond_with(@move)
  end

  def edit
  end

  def create
    @move = Move.new(move_params)
    @move.save
    respond_with(@move)
  end

  def update
    @move.update(move_params)
    respond_with(@move)
  end

  def destroy
    @move.destroy
    respond_with(@move)
  end

  private
    def set_move
      @move = Move.find(params[:id])
    end

    def move_params
      params.require(:move).permit(:user_id, :match_id, :square_id, :value)
    end
end

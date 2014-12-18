class User < ActiveRecord::Base
  has_many :matches, foreign_key: :player_x
  has_many :matches, foreign_key: :player_o
  has_many :moves
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :rememberable, :trackable, :validatable

  mount_uploader :user_image, UserImageUploader







  end

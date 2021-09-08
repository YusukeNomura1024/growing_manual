class Manual < ApplicationRecord
  belongs_to :user

  has_many :bookmarks, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  has_many :messages, dependent: :destroy

  attachment :image
end
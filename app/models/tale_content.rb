class TaleContent < ApplicationRecord
  belongs_to :tale
  has_one_attached :image
  has_one_attached :audio
  enum content_type: { text: 0, void: 1, image: 2 }
end

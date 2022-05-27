class Favourite < ApplicationRecord
  belongs_to :favouriter, class_name: 'User'
  belongs_to :favourited, class_name: 'Tale'
end

class Request < ApplicationRecord
  belongs_to :user
  enum status: { seen: 0, notseen: 1 }
end

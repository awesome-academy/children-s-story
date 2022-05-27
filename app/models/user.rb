class User < ApplicationRecord
  scope :new_user_month_now, -> { where('created_at >= ?', Time.zone.now.beginning_of_month) }
  scope :new_user_last_month, -> { where('created_at >= ?', Time.zone.now.beginning_of_month - 1.month) }
  scope :new_user_two_month_ago, -> { where('created_at >= ?', Time.zone.now.beginning_of_month - 2.months) }
  scope :new_user_three_month_ago, -> { where('created_at >= ?', Time.zone.now.beginning_of_month - 3.months) }
  has_one :request
  has_many :tales, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :reviewtales, class_name: 'Reviewtale', dependent: :destroy

  has_many :active_favourites, class_name: 'Favourite',
                               foreign_key: 'favouriter_id', dependent: :destroy
  has_many :favouriting, through: :active_favourites, source: :favourited

  attr_accessor :remember_token

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def self.search(term)
    if term
      where('name LIKE ?', "%#{term}%")
    else
      all
    end
  end

  class << self
    def digest(string)
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def follow(tale)
    Relationship.find_or_create_by! follower_id: id, followed_id: tale.id
  end

  def unfollow(tale)
    Relationship.find_by(follower_id: id, followed_id: tale.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(tale)
    following.include?(tale)
  end

  def favourite(tale)
    Favourite.find_or_create_by! favouriter_id: id, favourited_id: tale.id
  end

  def unfavourite(tale)
    Favourite.find_by(favouriter_id: id, favourited_id: tale.id).destroy
  end

  # Returns true if the current user is following the other user.
  def favouriting?(tale)
    favouriting.include?(tale)
  end
end

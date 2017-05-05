class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy

  validates :name, length: { minimum: 3 }, uniqueness: true

  def build_review(review_params, user)
    review_params[:user] ||= user
    reviews.new(review_params)
  end
end

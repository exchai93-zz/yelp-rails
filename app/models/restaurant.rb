class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :reviews,
        -> { extending WithUserAssociationExtension },
        dependent: :destroy

  validates :name, length: { minimum: 3 }, uniqueness: true

  def build_review(review_params, user)
    reviews.build_with_user(review_params, user)
  end

end

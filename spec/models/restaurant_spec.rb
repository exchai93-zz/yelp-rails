require 'rails_helper'
describe Restaurant, type: :model do

  it {is_expected.to belong_to(:user)}

  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: 'kf')
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it 'is not valid unless it has a unique name' do
    user = User.create(email: 'test@test.test', password: 'password', password_confirmation: 'password')
    user.restaurants.create(name: "Moe's tavern")
    restaurant = user.restaurants.create(name: "Moe's tavern")
    expect(restaurant).to have(1).error_on(:name)
  end

  describe 'reviews' do
    describe 'build_with_user' do
      let(:user) { User.create email: 'test@test.test' }
      let(:restaurant) { Restaurant.create name: 'test' }
      let(:review_params) { {rating: 5, thoughts: 'average'} }

      subject(:review) { restaurant.reviews.build_with_user(review_params, user) }

      it 'builds a review' do
        expect(review).to be_a Review
      end

      it 'builds a review associated with the specified user' do
        expect(review.user).to eq user
      end
    end
  end

end

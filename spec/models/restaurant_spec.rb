require 'rails_helper'
RSpec.describe Restaurant, type: :model do

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

end

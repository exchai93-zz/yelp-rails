require 'rails_helper'

feature 'reviewing' do

  before do
    User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')
    visit '/'
    click_link 'Sign in'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
  end

  scenario 'allows user to leave a review using a form' do
    user = User.first
    user.restaurants.create(name: 'KFC')
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: 'so so'
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content 'so so'
  end
end

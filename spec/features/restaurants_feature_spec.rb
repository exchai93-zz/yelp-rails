require 'rails_helper'

feature 'Restaurants' do
  before do
    User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')
    visit '/'
    click_link 'Sign in'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
  end

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do

    scenario 'display restaurants' do
      user = User.first
      user.restaurants.create(name: 'KFC')
      visit '/restaurants'
      expect(page).to have_content 'KFC'
      expect(page).not_to have_content 'No restaurants yet'
    end
  end

  context 'creating restaurants' do
    scenario 'prompt user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end
  end

    context 'invalid restaurant' do
      scenario 'does not let user submit a name that is too short' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end

  context 'viewing restaurants' do

    scenario 'lets a user view a restaurant' do
      user = User.first
      user.restaurants.create(name: 'KFC')
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{user.restaurants.first.id}"
    end
  end

  context 'editing restaurants' do
    scenario 'let a user edit a restaurant' do
      user = User.first
      user.restaurants.create(name: 'KFC', description: 'deep fried goodness', id: 1)
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'deep fried goodness'
      click_button 'Update Restaurant'
      click_link 'Kentucky Fried Chicken'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(page).to have_content 'deep fried goodness'
      expect(current_path).to eq '/restaurants/1'
    end
  end

  context 'deleting restaurants' do

    scenario 'removes a restaurant when user clicks delete link' do
      user = User.first
      user.restaurants.create(name: 'KFC', description: 'deep fried goodness')
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end
  end

  context 'logged out' do
    before do
      user = User.first
      user.restaurants.create name: 'KFC', description: 'deep fried goodness'
      visit '/'
      click_link 'Sign out'
    end

    scenario 'raises an error when adding a restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      expect(page).to have_content 'Log in'
    end

    scenario 'redirects to the log in page when trying to edit restaurant' do
      visit '/restaurants'
      click_link 'Edit KFC'
      expect(page).to have_content 'Log in'
    end

    scenario 'redirects to the log in page when trying to delete restaurant' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).to have_content 'Log in'
    end
  end

end

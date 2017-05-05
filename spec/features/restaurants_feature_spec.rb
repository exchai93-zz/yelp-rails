require 'rails_helper'

feature 'Restaurants' do

  context 'no restaurants have been added' do
    before do
      sign_up
    end
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      sign_up
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content 'KFC'
      expect(page).not_to have_content 'No restaurants yet'
    end
  end

  context 'creating restaurants' do
    before do
      sign_up
    end
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
      before do
        sign_up
      end
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
    let!(:kfc){ Restaurant.create(name: 'KFC')}
    before do
      sign_up
    end

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    before do
      sign_up
    end
    before {Restaurant.create name: 'KFC', description: 'deep fried goodness', id: 1}
    scenario 'let a user edit a restaurant' do
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
    before  do
      sign_up
      Restaurant.create name: 'KFC', description: 'deep fried goodness'
    end
    scenario 'removes a restaurant when user clicks delete link' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end
  end

  context 'logged out' do
    before do
      sign_up
      Restaurant.create name: 'KFC', description: 'deep fried goodness'
      visit '/'
      click_link 'Sign out'
    end

    scenario 'raises an error when adding a restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      expect(page).to have_content 'Log in'
    end
  end


end

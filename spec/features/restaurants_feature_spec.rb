require 'spec_helper'

describe 'the restaurant index page' do 
  
  context 'no restaurants have been added' do
    it 'should display a warning message' do
      visit '/restaurants'
      expect(page).to have_content('No restaurants have been added yet')
    end



    describe 'adding a restaurant' do

      context 'logged out' do
        it 'takes me to the signed in page' do
          visit '/restaurants'
          click_link 'Add a restaurant' 
          expect(current_path).to eq '/users/sign_in'
          expect(page).to have_content('Sign in')
        end

      end

      context 'logged in' do 

        before do
          login_as_test_user
        end

        it 'should be listed on the index' do
          visit '/restaurants'
          click_link 'Add a restaurant'
          fill_in 'Name', with: 'KFC'
          fill_in 'Category', with: 'Fastfood'
          fill_in 'Location', with: 'Everywhere'
          click_button 'Create Restaurant'
          expect(current_path).to eq '/restaurants'
          expect(page).to have_content 'KFC'
        end
      end
    end
  end

  context 'with existing restaurants' do
      
    let!(:restaurant) { Restaurant.create(:name => 'McDonalds', :category => 'fastfood') }

    describe 'editing a restaurant' do
      it 'should update the restaurant details' do
        visit '/restaurants'

        first('.restaurant_item').click_link 'Edit'

        fill_in 'Name', with: 'Old McDonalds'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Old McDonalds'
      end
    end

    describe 'deleting a restaurant' do
      it 'should permanently destroy the restaurant' do
        visit '/restaurants'

        first('.restaurant_item').click_link 'Delete'
      
        expect(page).not_to have_content 'McDonalds'
        expect(page).to have_content 'Restaurant deleted successfully!'
      end
    end
  end
end

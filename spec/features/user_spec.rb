require 'rails_helper'

RSpec.describe User do
  let!(:user) { FactoryBot.create(:user) }

  scenario 'navigation' do
    visit '/admin'
    click_on 'Users' # li.menu_item#users'
    expect(current_path).to eq admin_users_path
    click_on user.id.to_s
    expect(current_path).to eq admin_user_path(user)
    expect(page).to have_css 'h2#page_title', text: user.username
    expect(page).to have_css 'h3', text: 'Order History'
  end

  context 'new user' do
    let(:user) { FactoryBot.build(:user) }

    scenario 'create' do
      visit admin_users_path
      click_on 'New User'
      expect(current_path).to eq new_admin_user_path(user)
      expect(page).to have_css 'h2', text: 'New User'
      fill_in 'Username', with: user.username
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Create User'
      expect(page).to have_css 'div.flash_notice', text: 'User was successfully created.'
    end
  end
end

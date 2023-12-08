require 'rails_helper'

RSpec.describe User do
  let!(:user) { FactoryBot.create(:user) }

  scenario 'navigation' do
    visit '/admin'

    click_on 'Users' # li.menu_item#users'
    expect(current_path).to eq admin_users_path
    expect(page).to have_css 'h2#page_title', text: 'Users'
    expect(page).to have_css 'table.index_table'
    expect(page).to have_css 'th', text: 'Username'
    expect(page).to have_css 'th', text: 'Email'
    expect(page).to have_css 'th', text: 'Created At'
    expect(page).to have_css 'td.col-username', text: user.username
    expect(page).to have_css 'td.col-email', text: user.email
    expect(page).to have_css 'td.col-created_at', text: user.created_at.to_fs(:long)
    expect(page).to have_css 'td.col-actions'
    expect(page).to have_css 'a.member_link', text: 'View'
    expect(page).to have_css 'a.member_link', text: 'Edit'
    expect(page).to have_css 'a.member_link', text: 'Delete'

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
      expect(page).to have_css '.row-username', text: user.username
      expect(page).to have_css '.row-email', text: user.email
    end
  end
end

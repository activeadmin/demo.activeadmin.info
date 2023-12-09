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
    expect(page).to have_css 'div.panel#customer-details_sidebar_section h3', text: 'Customer Details'
    within 'div.panel#customer-details_sidebar_section' do
      within 'div.panel_contents table' do
        expect(page).to have_css 'tr.row-username td', text: user.username
        expect(page).to have_css 'tr.row-email td', text: user.email
        expect(page).to have_css 'tr.row-created_at td', text: user.created_at.to_fs(:long)
      end
    end
    expect(page).to have_css 'div.panel#order-history_sidebar_section h3', text: 'Order History'
    within 'div.panel#order-history_sidebar_section' do
      within 'div.panel_contents table' do
        expect(page).to have_css 'tr.row-total_orders', text: 'Total Orders'
        expect(page).to have_css 'tr.row-total_value', text: 'Total Value'
      end
    end
    expect(page).to have_css 'div.panel#active-admin-demo_sidebar_section h3', text: 'Active Admin Demo'
    within 'div.panel#active-admin-demo_sidebar_section' do
      expect(page).to have_css 'div.panel_contents', text: /This is the demo app for Active Admin/
      expect(page).to have_link 'source code for this page',
        href: 'https://github.com/varyonic/demo.activeadmin.info/blob/main/app/admin/users.rb'
    end
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

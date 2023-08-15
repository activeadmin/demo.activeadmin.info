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
end

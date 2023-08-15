require 'rails_helper'

RSpec.describe 'Dashboard' do
  scenario 'navigation' do
    visit '/admin'
    click_on 'Dashboard'
    expect(current_path).to eq admin_dashboard_path
    expect(page).to have_css 'h2#page_title', text: 'Dashboard'
    expect(page).to have_css 'h3', text: 'Recent Orders'
  end
end

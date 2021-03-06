require 'rails_helper'
require 'yaml'

RSpec.feature "Bento Searches", type: :feature do
  let (:fixtures) {
    YAML.load_file("#{fixture_path}/search_features.yml")
  }
  feature "Search all fields" do
    let (:item) { fixtures.fetch("book_search") }
    scenario "Search Title" do
      visit '/bento'
      within("div.hero-unit") do
      fill_in 'q', with: item['title']
      click_button
    end
      within("h4") do
        expect(page).to have_text item['title']
      end
    end
  end
end

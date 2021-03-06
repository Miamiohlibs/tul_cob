require 'rails_helper'
require 'traject'
require 'traject/command_line'
require 'yaml'
require 'pry'

RSpec.feature "Indices", type: :feature do
  let (:fixtures) {
    YAML.load_file("#{fixture_path}/features.yml")
  }

  feature "Home Page" do
    context "publicly available pages" do
      scenario "User visits home page" do
        visit '/'
        expect(page).to have_text "Welcome!"
        within("#facets") do
            expect(page).to have_text "Date"
            expect(page).to have_text "Resource Type"
        end
      end

    end
  end

  feature "Facets" do
    let (:facets) {
      [ "Availability",
        "Library",
        "Resource Type",
        "Date",
        "Author/creator",
        "Topic",
        "Era",
        "Region",
        "Genre",
        "Language"]
    }
    context "publicly available pages" do
      scenario "User visits home page" do
        visit '/'
        within("#facets") do
          all('div.panel').each_with_index do |div_panel, i|
            expect(div_panel).to have_text facets[i]
          end
        end
      end
    end
  end

  feature "Catalog" do
    let (:title) { "Academic freedom in an age of conformity" }
    let (:results_url) { "http://www.example.com/?utf8=%E2%9C%93&search_field=all_fields&q=Academic+freedom+in+an+age+of+conformity" }
    scenario "Search" do
      visit '/'
      fill_in 'q', with: title
      click_button 'Search'
      expect(current_url).to eq results_url
      within(".document-position-0 h3") do
        expect(page).to have_text(:title)
      end
      within(".document-metadata") do
        expect(page).to have_text :title
        expect(page).to have_text "Resource Type:"
        expect(page).to have_text "Book"
        expect(page).to have_text "Status/Location:"
        expect(page).to have_text "Author/creator:"
        expect(page).to have_text "Published:"
        has_css?(".avail-button", :visible => true)
      end
    end
  end

  feature "Document" do
    let (:item) {
      fixtures.fetch("simple_search")
    }

    let (:item_url) {
      "#{Capybara.default_host}/catalog/#{item['doc_id']}"
    }

    scenario "Search" do
      visit '/'
      fill_in 'q', with: item['title']
      click_button 'Search'
      expect(current_url).to eq item['url']
      within(".document-position-0") do
        click_link item['title']
        expect(current_url).to eq item_url
        within("h3") do
          expect(page).to have_text item['title']
        end
        click_link item['title']
      end
    end

    scenario "User visits a document directly" do
      visit "catalog/#{item['doc_id']}"
      expect(current_url).to eq item_url
      expect(page).to have_text(item['title'])
    end
  end
end

# frozen_string_literal: true

RSpec.describe "Sidebar New Topic Button", system: true do
  fab!(:theme) { upload_theme_component }

  it "does not render the sidebar button for anons" do
    visit("/latest")
    expect(page).not_to have_css(".sidebar-new-topic-button__wrapper")
    expect(page).not_to have_css(".sidebar-new-topic-button:not(.disabled)")
  end  
end
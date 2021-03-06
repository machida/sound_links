# frozen_string_literal: true

require "rails_helper"

RSpec.describe "楽曲検索機能", type: :system do
  before do
    mock_search_results
  end

  it "検索した楽曲のSpotify・Apple Music・KKBOXのURLを表示できる" do
    visit root_path
    fill_in "keyword", with: "リライト"
    click_on "Search"

    expect(page).to have_content "ASIAN KUNG-FU GENERATION"
    expect(page).to have_selector ".spotify-url", text: "https://open.spotify.com/track/3h5e4tpgR9q0cjQXzo8FMD?si=WN7JPlJ5SuSQhrhh9Z-8Yw"
    expect(page).to have_selector ".apple-music-url", text: "https://music.apple.com/jp/album/%E3%83%AA%E3%83%A9%E3%82%A4%E3%83%88/570003767?i=570003920"
    expect(page).to have_selector ".kkbox-url", text: "https://www.kkbox.com/jp/ja/song/FcqGD-90I.n6HlVI7lVI70P4-index.html"
  end
end

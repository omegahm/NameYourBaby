require_relative "../spinner"

namespace :web do
  PAGES = 20 # there's 30 names per page

  desc "Scrape navneguiden.dk"
  task scrape: %I[ environment scrape_girls scrape_boys ]

  task scrape_girls: :environment do
    puts "Scraping girls..."
    headers = %W[position name gender]
    CSV.open(Rails.root + "db/seeds/navneguiden_girls.csv", "w", headers: headers, write_headers: true) do |csv|
      PAGES.times do |page|
        spin(page+1, PAGES, speed: 1)

        url = "https://www.navneguiden.dk/populaere-pigenavne?page=#{page+1}"
        response = HTTParty.get(url)
        document = Nokogiri::HTML(response.body)

        document.css("ul.aon-name-listing__list li").each do |list_item|
          position = list_item.css(".aon-name-listing__link-number").text
          name = list_item.css("a div")[0].text.sub(/^[0-9]+/, "")
          gender = list_item.css("circle")[0].attr("style").match(/\d+/).to_s
          csv << [ position, name, gender ]
        end

        sleep 2
      end
    end
    puts "\nDone."
  end

  task scrape_boys: :environment do
    puts "Scraping boys..."
    headers = %W[position name gender]
    CSV.open(Rails.root + "db/seeds/navneguiden_boys.csv", "w", headers: headers, write_headers: true) do |csv|
      PAGES.times do |page|
        spin(page+1, PAGES, speed: 1)

        url = "https://www.navneguiden.dk/populaere-drengenavne?page=#{page+1}"
        response = HTTParty.get(url)
        document = Nokogiri::HTML(response.body)

        document.css("ul.aon-name-listing__list li").each do |list_item|
          position = list_item.css(".aon-name-listing__link-number").text
          name = list_item.css("a div")[0].text.sub(/^[0-9]+/, "")
          gender = list_item.css("circle")[0].attr("style").match(/\d+/).to_s
          csv << [ position, name, gender ]
        end

        sleep 2
      end
    end
    puts "\nDone."
  end
end

class Nasa
  require 'httparty'
  require 'nokogiri'
  require 'sanitize'

  def initialize
    @page_link = 'https://www.nasa.gov/press-release/nasa-industry-to-collaborate-on-space-communications-by-2025'
    @api_base = 'https://www.nasa.gov/api/2'
  end

  def call
    unparsed_html = HTTParty.get(@page_link)
    page = Nokogiri::HTML(unparsed_html)

    node_id = page.search('script').map {|s| s.content.to_s.split("window.forcedRoute = \"").last.to_s.gsub("\"","") if s.content.to_s.include?("window.forcedRoute") }.compact.last

    return "No data in node" if node_id.nil?
    
    options = {
      headers: {
        "Content-Type": "application/json"
      }
    }

    response = HTTParty.get(@api_base + node_id, options)

    return "No data in body" if response.body.nil? || response.body.empty?

    data =  JSON.parse(response.body)["_source"]

    return "No data in source" if data.nil?

    body_html =  Nokogiri::HTML(data["body"])

    body_data = body_html.search("p").map { |ele| ele.text }.reject { |e| e.to_s.empty? or e.to_s=="-end-" }

    result = {
      title: data["title"],
      date: data["promo-date-time"],
      release_no: data["release-id"],
      article: body_data.join(" ")
    }
  end
end

puts Nasa.new.call
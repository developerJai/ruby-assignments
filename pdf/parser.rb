class Parser
  require 'nokogiri'
  require 'pdf/reader/html'


  def initialize
    @file_path = "pdf/files/"
    @result = []
  end

  def call
    Dir.foreach(@file_path) do |filename|
      next unless filename.include? '.pdf'

      file_loc = @file_path + filename
      reader = PDF::Reader.new(file_loc)

      reader.info[:Title]
      next unless reader.info[:Title].to_s.include?("Judgment for Costs of Appointed Attorney")

      page = Nokogiri::HTML(reader.to_html)
      content = {}

      page.search('p').each do |ele|
        ele_content = ele.text

        if ele_content.include?(", Supreme Court No.")
          content[:petitioner] = ele_content.split(",").first

        elsif ele_content.include?("$")
          data_elements = ele_content.split(" $")
          content[:amount] = "$" + data_elements.last.to_s.split(", ").first.to_s.split(". ").first.gsub("$","")
          # content[:state] = data_elements.first.split("shall pay to ").last

        elsif ele_content.include?("Supreme Court of the")
          content[:state] = ele_content.split("Court of the ").last

        elsif ele_content.include?("Date of Notice:")
          date_element = ele_content.split(": ").last.to_s.split("/")
          year = date_element.last.to_s
          month = date_element.first
          day = date_element[1]

          content[:date] = "#{year.size==2 ? '20'+year : year}-#{"%02d" % month}-#{"%02d" % day}"
        end
      end

      @result << content unless content.empty?
    end

    return @result
  end
end

puts Parser.new.call
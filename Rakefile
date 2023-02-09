task default: %w[test]
namespace :scrapper  do
  desc "Data from nasa web page"
  task :nasa do
    ruby 'scrapper/nasa.rb'
  end
end

namespace :pdf  do
  desc "Parsing PDFs data"
  task :parser do
    ruby 'pdf/parser.rb'
  end
end
module ImageSearch
  require 'google-search'
  require 'open-uri'
  require 'fileutils'

  module_function

  def search(animal)
    Google::Search::Image.new(
      :query => "\"baby #{animal}\"",
      :image_size => [:large, :xlarge, :xxlarge]
    ).map(&:uri).slice(0,5).reject do |uri|
      uri.downcase.end_with?('.bmp')
    end.sample
  end

  def get_and_store_image_for(animal)
    uri = search(animal)
    FileUtils::mkdir_p("./images/")

    file_path = "./images/" +
                animal.gsub(' ','_') + '_' +
                Time.new.strftime('%Y%m%d%H%M') +
                File.extname(uri)

    open(file_path, 'wb') do |file|
      file << open(search(animal)).read
    end

    file_path
  end

end
module ImageSearch
  require 'google-search'
  require 'open-uri'

  module_function

  def search(query)
    Google::Search::Image.new(
      :query => query,
      :image_size => [:medium, :large, :xlarge]
    ).map(&:uri).slice(0,10).reject do |uri|
      uri.downcase.end_with?('.bmp')
    end.sample
  end

  def get_and_store_image_for(query)
    uri = search(query)

    file_path = query.gsub(' ','_') + '_' +
                Time.new.strftime('%Y%m%d%H%M') +
                File.extname(uri)

    open("images/#{file_path}", 'wb') do |file|
      file << open(search(query)).read
    end

    file_path
  end

end
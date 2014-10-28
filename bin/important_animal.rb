module ImportantAnimal
  require 'rubygems'
  require 'chatterbot/dsl'
  require 'date'
  load 'image_search.rb'
  load 'text_composition.rb'

  module_function

  # Set up credentials for @ImportantAnimal twitter app.
  # Use a yml file in development, and a Heroku's
  # ENV in production.
  CREDS = if File.exists?('important_animal.yml')
            puts "Reading config from important_animal.yml"
            YAML.load_file('important_animal.yml')
          else
            ENV
          end


  consumer_key CREDS['consumer_key']
  consumer_secret CREDS['consumer_secret']
  secret CREDS['secret']
  token CREDS['token']

  # If provided, tweet one in every FREQUENCY times
  # the script is executed.
  FREQUENCY = ARGV[0] ? ARGV[0].to_i : nil

  # Don't perform public actions in test mode.
  TEST_MODE = ARGV[1] == 'test'

  GENDER = [:male, :female].sample

  def run(opts={})
    frequency = FREQUENCY || opts[:frequency] || 8
    test_mode = TEST_MODE || opts[:testing]

    its_daytime = (8..23).cover?(Time.now.getlocal("-04:00").hour)

    puts "*"*10
    if rand(frequency) == 0
      if its_daytime || test_mode

        params, text = get_params_and_tweet_text
        path_to_image = get_image_path(params[:animal])

        if test_mode
          puts "TESTING MODE. NOT TWEETING."
          puts "TEXT: #{text}"
          puts "IMAGE PATH: #{path_to_image}"
        else
          puts "TWEETING: #{text}"
          client.update_with_media(text, File.new(path_to_image))
        end
      else
        puts "TOO LATE TO TWEET. STAYING SILENT"
      end
    else
      puts "BAD LUCK. STAYING SILENT."
    end
    puts "*"*10
  end

  def get_params_and_tweet_text
    params = {
      :name => eval("get_#{GENDER.to_s}_name"),
      :animal => get_animal,
      :trade => get_trade,
      :place => get_place,
      :gender => GENDER
    }

    text = TextComposition.new(params).tweet_text

    [params, text]
  end

  def get_image_path(animal)
    ImageSearch.get_and_store_image_for(animal)
  end

  ['animal', 'trade', 'place',
   'male_name', 'female_name'].each do |word_type|
    define_singleton_method('get_' + word_type) do
      random_line("data/#{word_type}s.txt")
    end
  end

  def random_line(file_path)
    File.readlines(file_path).sample.delete("\n")
  end

end

ImportantAnimal.run
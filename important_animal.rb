module ImportantAnimal
  require 'rubygems'
  require 'chatterbot/dsl'
  require 'namey'
  load 'image_search.rb'

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


  @namey = Namey::Generator.new
  @gender = [:male, :female].sample

  def get_name
    rareness = rand(90)

    @namey.generate(
      :type => @gender,
      :with_surname => false,
      :min_freq => rareness,
      :max_freq => rareness + 10
    )
  end

  ['animal', 'trade', 'place'].each do |word_type|
    define_singleton_method('get_' + word_type) do
      random_line("data/#{word_type}s.txt")
    end
  end

  def get_image_path(animal)
    ImageSearch.get_and_store_image_for("baby #{animal}")
  end


  def run
    puts get_name
    puts (animal = get_animal)
    puts (trade = get_trade)
    puts (place = get_place)
  end

  ###
  # Utils
  ###

  def random_line(file_path)
    File.readlines(file_path).sample.delete("\n")
  end


end

ImportantAnimal.run
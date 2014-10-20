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


  def compose_sentence(params, version)
    name, animal, trade, place = params[:name], params[:animal], params[:trade], params[:place]
    him_her, he_she = gender_to_accusative(@gender), gender_to_nominative(@gender)

    case version
      when 1
        "Meet #{name}. This #{animal} is #{indef_phrase(trade)} from #{place}. Check #{him_her} out!"
      when 2
      when 3
    end
  end

  def run
    name = get_name
    animal = get_animal
    trade = get_trade
    place = get_place
    #image = get_image_path(animal)

  end

  ###
  # Utils
  ###

  def random_line(file_path)
    File.readlines(file_path).sample.delete("\n")
  end

  def indef_phrase(noun)
    initial_vowel = noun[0] =~ /[aeiou]/
    article = if !initial_vowel || noun.starts_with?('utility')
      'a'
    else
      'an'
    end

    article + ' ' + noun
  end

  def gender_to_nominative(gender)
    gender == :male ? 'he' : 'she'
  end

  def gender_to_accusative(gender)
    gender == :male ? 'him' : 'her'
  end


end

ImportantAnimal.run
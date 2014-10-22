module ImportantAnimal
  require 'rubygems'
  require 'chatterbot/dsl'
  require 'namey'
  require 'date'
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

  AVAIBLE_CHARS = 117
  DAY = Date::DAYNAMES[Date.today.wday]

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
    him_her = @gender == :male ? 'him' : 'her'
    he_she = @gender == :male ? 'he' : 'she'
    his_her = @gender == :male ? 'his' : 'her'

    body = case version
      when 1
        "Meet #{name}. This #{animal} is #{indef_phrase(trade)} from #{place}."
      when 2
        "#{name} the #{animal} here. #{he_she.capitalize}'s #{indef_phrase(trade)} who makes #{his_her} home in #{place}."
      when 3
        "#{trade.capitalize} and #{animal} #{name} is not your average animal."
      when 4
        "#{name} the #{trade} from #{place} is at your service."
      when 5
        "As #{indef_phrase(trade)} of some renownn, #{name} the #{animal} lives the good life in #{place}."
      when 6
        "In #{place}, #{name} the #{animal} found work as #{indef_phrase(trade)}."
    end

    prefix = [
      "Oh boy!",
      "Aw yeah.",
      "Who's that?",
      "Look!",
      "What a sight!",
      "Yo.",
      "Animal time.",
      "#{he_she.capitalize} came to party.",
      "Look out.",
      "Watch out now.",
      "Alert!",
      "Well, I'll be.",
      "Nothing to see here.",
      "Is #{he_she} the best animal?",
      "Ahoy!",
      "Unbelievable.",
      "What are the chances?",
      "Cuddle much?",
      "Pay attention!",
      "Professional to the max:",
      "So: ",
      "Perhaps you've heard...",
      "In other news: ",
      "Happy #{DAY}!"
    ].sample

    suffix = [
      "Check #{him_her} out!",
      "#{he_she.capitalize}'s a doll.'",
      "Don't hate the player.",
      "A legend.",
      "An animal on a mission.",
      "#{he_she.capitalize} came to party.",
      "Good times.",
      "#{he_she.capitalize} knows exactly what #{he_she}'s doing.",
      "Unrivaled.",
      "Peerless.",
      "Unflappable.",
      "Breathtaking.",
      "Magestic.",
      "#{he_she.capitalize}'s got a heart of gold.",
      "On top of #{his_her} game.",
      "Mysterious.",
      "Can't make this up.",
      "Last of #{his_her} kind.",
      "There's #{DAY} for ya."
    ].sample

    prefix + ' ' + body + ' ' + suffix
  end


  def run
    params = {
      :name => get_name,
      :animal => get_animal,
      :trade => get_trade,
      :place => get_place,
    }

    sentence =  compose_sentence(params, (1..6).to_a.sample)
    puts sentence
    puts sentence.length
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
    article = if !initial_vowel || noun[0,7] == 'utility'
      'a'
    else
      'an'
    end

    article + ' ' + noun
  end


end

ImportantAnimal.run
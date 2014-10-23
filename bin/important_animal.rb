module ImportantAnimal
  require 'rubygems'
  require 'chatterbot/dsl'
  require 'namey'
  require 'date'
  load 'bin/image_search.rb'

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
    ImageSearch.get_and_store_image_for(animal)
  end


  def compose_text(params)
    name, animal, trade, place = params[:name], params[:animal], params[:trade], params[:place]
    him_her = @gender == :male ? 'him' : 'her'
    he_she = @gender == :male ? 'he' : 'she'
    his_her = @gender == :male ? 'his' : 'her'

    lives_in_place = ([
      "makes #{his_her} home in",
      'lives in',
      'lives the good life in',
      "spends #{his_her} days in",
      'resides in',
      'basically rules',
      'dreams of',
      'is the mayor of',
      'rocks out in'
    ].sample + " #{place}")

    body = [
        "Meet #{name}. This #{animal} is #{indef_phrase(trade)} from #{place}.",
        "#{name} the #{animal} here. #{he_she.capitalize}'s #{indef_phrase(trade)} who #{lives_in_place}.",
        "#{trade.capitalize} and #{animal} #{name} is not your average animal.",
        "#{trade.capitalize} and #{animal} #{name} #{lives_in_place}.",
        "#{name} the #{trade} from #{place} is at your service.",
        "As #{indef_phrase(trade)} of some renown, #{name} the #{animal} #{lives_in_place}.",
        "In #{place}, #{name} the #{animal} found work as #{indef_phrase(trade)}.",
        "In #{place}, #{name} found work as #{indef_phrase(trade)}.",
        "#{name} the #{animal}. Just being #{his_her} bad self.",
        "#{name} the #{animal}. Just being #{his_her} bad self in #{place}.",
        "#{name} #{lives_in_place}. #{he_she.capitalize}'s #{indef_phrase(animal)}, of course.",
        "Who #{lives_in_place}? #{name} the #{animal} -- duh! #{he_she.capitalize}'s #{indef_phrase(trade)}.",
        "Everyone's favorite #{trade}: #{name} the #{animal}."
    ].sample


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
      "Ahoy!",
      "Unbelievable.",
      "What are the chances?",
      "Cuddle much?",
      "Pay attention!",
      "Professional to the max:",
      "So: ",
      "Perhaps you've heard...",
      "In other news: ",
      "Happy #{DAY}!",
      "LOL."
    ].sample

    suffix = [
      "Check #{him_her} out!",
      "Is #{he_she} the best animal?",
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


    text = body

    # Start over if the text is already too long.
    if text.length > AVAIBLE_CHARS
      return compose_text(params)
    end

    if rand < 0.6 && (prefixed = [prefix, text].join(' ')).length < AVAIBLE_CHARS
      text = prefixed
    end

    if rand < 0.6 && (suffixed = [text, suffix].join(' ')).length < AVAIBLE_CHARS
      text = suffixed
    end

    text
  end


  def run
      params = {
        :name => get_name,
        :animal => get_animal,
        :trade => get_trade,
        :place => get_place,
      }

      text = compose_text(params)
      path_to_image = get_image_path(params[:animal])
      puts

      client.update_with_media(text, File.new(path_to_image))
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
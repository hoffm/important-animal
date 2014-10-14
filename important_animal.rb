module ImportantAnimal
  require 'rubygems'
  require 'chatterbot/dsl'
  require 'namey'

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

  def name
    rareness = rand(90)

    @namey.generate(
      :type => @gender,
      :with_surname => false,
      :min_freq => rareness,
      :max_freq => rareness + 10
    )
  end



  def run
    puts name
  end


end

ImportantAnimal.run
module ImportantAnimal
  require 'rubygems'
  require 'chatterbot/dsl'

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


end

class TextComposition

  AVAILABLE_CHARS = 117
  DAY = Date::DAYNAMES[Date.today.wday]
  
  def initialize(params)
    @name, @animal = params[:name], params[:animal]
    @trade, @place = params[:trade], params[:place]
    @gender = params[:gender]
    @him_her = @gender == :male ? 'him' : 'her'
    @he_she = @gender == :male ? 'he' : 'she'
    @his_her = @gender == :male ? 'his' : 'her'
    @man_woman = @gender == :male ? 'man' : 'woman'
  end

  def tweet_text
    text = body

    # Start over if the text is already too long.
    if text.length > AVAILABLE_CHARS
      return tweet_text
    end

    with_preamble = [preamble, text].join(' ')
    if rand < 0.6 && with_preamble.length < AVAILABLE_CHARS
      text = with_preamble
    end

    with_afterward = [text, afterward].join(' ')
    if rand < 0.6 && with_afterward.length < AVAILABLE_CHARS
      text = with_afterward
    end

    text
  end

  def lives_in_place
    [
      "makes #{@his_her} home in",
      'lives in',
      'lives the good life in',
      "spends #{@his_her} days in",
      'resides in',
      'basically rules',
      'dreams of',
      'is the mayor of',
      'rocks out in',
      'chills in',
      'lives it up in',
      "moved #{@his_her} family to"
    ].sample + " #{@place}"
  end

  def body
    [
      "Meet #{@name}. This #{@animal} is #{indef_phrase(@trade)} from #{@place}.",
      "#{@name} the #{@animal} here. #{@he_she.capitalize}'s #{indef_phrase(@trade)} who #{lives_in_place}.",
      "#{@trade.capitalize} (and #{@animal}) #{@name} #{lives_in_place}.",
      "#{@name} the #{@trade} from #{@place} is at your service.",
      "As #{indef_phrase(@trade)} of some renown, #{@name} the #{@animal} #{lives_in_place}.",
      "In #{@place}, #{@name} the #{@animal} found work as #{indef_phrase(@trade)}.",
      "In #{@place}, #{@name} found work as #{indef_phrase(@trade)}.",
      "#{@name} the #{@animal}. Just being #{@his_her} bad self.",
      "#{@name} the #{@animal}. Just being #{@his_her} bad self in #{@place}.",
      "#{@name} #{lives_in_place}. #{@he_she.capitalize}'s #{indef_phrase(@animal)}, of course.",
      "Who #{lives_in_place}? #{@name} the #{@animal} -- duh! #{@he_she.capitalize}'s #{indef_phrase(@trade)}.",
      "Everyone's favorite #{@trade}: #{@name} the #{@animal}.",
      "The #{@trade}s in #{@place} have nothing but respect for #{@name} the #{@animal}.",
      "Many #{indef_phrase(@animal)} envies #{@name}'s career as a #{@trade}.",
      "This is #{@name}. Do you know a finer #{@trade} from #{@place}? What #{indef_phrase(@animal)}.",
      "If you're in need of #{indef_phrase(@trade)}, #{@name} is your #{@man_woman}. Always go #{@animal}.",
      "Though #{@he_she} #{lives_in_place}, #{@name} is a globetrotting #{@animal}.",
      "Introducing the #{@animal} of the hour: #{@name} the #{@trade} from #{@place}!",
      "Presenting the #{@trade} of the hour: #{@name} the #{@animal} from #{@place}!",
      "#{@he_she.capitalize} answers to \"#{@name}\". Or to \"#{@name} the super #{@trade}\".",
      "Visiting #{@place}? Why not pay a visit to this #{@animal}, #{@name} the #{@trade}?.",
      "#{@name}'s #{@his_her} name. Being #{indef_phrase(@trade)}'s #{@his_her} game.",
      "Say a friendly hello to #{@name} the #{@animal}. #{@he_she.capitalize} is dating #{indef_phrase(@trade)} from #{@place}.",
      "Say hi to #{@name} the #{@animal}. #{@he_she.capitalize}'s #{indef_phrase(@trade)} from #{@place}.",
      "#{@animal.capitalize} alert! #{@name} is in the house repping #{@place} where #{@he_she} is #{indef_phrase(@trade)}.",
      "Which #{@animal} #{lives_in_place}? None other than #{@name} the #{@animal}!"
    ].sample
  end

  def preamble
    [
      "Oh boy!",
      "Aw yeah.",
      "Who's that?",
      "Look!",
      "What a sight!",
      "Yo.",
      "Animal time.",
      "#{@he_she.capitalize} came to party.",
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
      "So:",
      "Perhaps you've heard...",
      "In other news: ",
      "Happy #{DAY}!",
      "LOL.",
      "OMG. OMG.",
      "Here's a familiar one:",
      "One for the books...",
      "Oh baby:",
      "Must see:",
      "Stop the presses!",
      "Oy!",
      "A special treat:",
      "What's that you say?",
      "Who else?",
      "Ready to be impressed?",
      "Ooo!",
      "My.",
      "My, my.",
      "My oh my.",
      "#{@man_woman.capitalize} of the hour!"
    ].sample
  end

  def afterward
    [
      "Check #{@him_her} out!",
      "Is #{@he_she} the best animal?",
      "#{@he_she.capitalize}'s a doll.",
      "Don't hate the player.",
      "A legend.",
      "An animal on a mission.",
      "#{@he_she.capitalize} came to party.",
      "Good times.",
      "#{@he_she.capitalize} knows exactly what #{@he_she}'s doing.",
      "Unrivaled.",
      "Peerless.",
      "Unflappable.",
      "Breathtaking.",
      "Magestic.",
      "What a serious #{(@gender == :male) ? 'fellow' : 'gal'}.",
      "#{@he_she.capitalize}'s got a heart of gold.",
      "On top of #{@his_her} game.",
      "Mysterious.",
      "Can't make this up.",
      "Last of #{@his_her} kind.",
      "There's #{DAY} for ya.",
      "Have you ever seen the like?",
      "Golly!",
      "Unprecedented.",
      "Zoom!",
      "Watch #{@him_her} go!",
      "Just lovely.",
      "Lovely.",
      "Smart.",
      "Master of #{@his_her} domain.",
      "A lover, not a fighter.",
      "Magnifique!",
      "What a happy #{@gender == :male ? 'guy' : 'gal'}.",
      "Will #{@he_she} become President some day?"
    ].sample
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
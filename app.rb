require 'rubygems'
require 'bundler'
Bundler.require

# Load configuration file with Sintra::Contrib helper (http://www.sinatrarb.com/contrib/)
config_file 'config.yml'

# Load some helper methods from helpers.rb
require './helpers.rb'

# To manage the web session coookies
use Rack::Session::Cookie, :key => 'rack.session'

# Setup Gabba, a server-side Google Analytics gem
G = Gabba::Gabba.new(settings.google_analytics["tracking_id"], settings.google_analytics["domain"]) if defined?(settings.google_analytics)
before do
  G.page_view(request.path.to_s,request.path.to_s) if defined?(G)
end

get '/' do
  redirect "http://github.com/marks/verify-vote"
end

get '/ballot/:serial_number' do
  all_ballots = load_spreadsheet_into_hash
  # matched_ballot gets set to the FIRST ballot found with the given serial number
  matched_ballot = all_ballots.find {|ballot| ballot['Serial Number'] == params[:serial_number] }
  matched_ballot.to_json
end

get '/ballots' do
  all_ballots = load_spreadsheet_into_hash
  all_ballots.to_json
end

# Resource called by the Tropo WebAPI URL setting
post '/index.json' do
  # Fetches the HTTP Body (the session) of the POST and parse it into a native Ruby Hash object
  v = Tropo::Generator.parse request.env["rack.input"].read

  # Fetching certain variables from the resulting Ruby Hash of the session details
  # into Sinatra/HTTP sessions; this can then be used in the subsequent calls to the
  # Sinatra application
  session[:network] = v[:session][:to][:network].upcase
  session[:channel] = v[:session][:to][:channel].upcase
  if defined?(G)
    G.set_custom_var(1, 'caller', v[:session][:from].values.join("|").to_s, Gabba::Gabba::VISITOR)
    G.set_custom_var(2, 'called', v[:session][:to].values.join("|").to_s, Gabba::Gabba::VISITOR)
    G.set_custom_var(3, 'session_id', v[:session][:session_id], Gabba::Gabba::VISITOR)
    G.set_custom_var(4, 'network', session[:network].to_s, Gabba::Gabba::VISITOR)
    G.set_custom_var(5, 'channel', session[:channel].to_s, Gabba::Gabba::VISITOR)
  end

  # Create a Tropo::Generator object which is used to build the resulting JSON response
  t = Tropo::Generator.new
    t.voice = settings.tropo_tts["voice"]

    # If there is Initial Text available, we know this is an IM/SMS/Twitter session and not voice
    if v[:session][:initial_text]
      # Set a session variable with the input the user sent when they sent the IM/SMS/Twitter request
      session[:input] = v[:session][:initial_text]
      t.ask :name => '0', :say => {:value => ""}, :choices => {:value => "[ANY]"}
    else
      # If this is a voice session, then add a voice-oriented ask to the JSON response with the appropriate options
      t.ask :name => 'input', :bargein => true, :timeout => settings.tropo_tts["timeout_for_#{session[:channel]}"], :interdigitTimeout => settings.tropo_tts["interdigitTimeout_for_#{session[:channel]}"],
          :attempts => 3,
          :say => [{:event => "timeout", :value => say_str("Sorry, I did not hear anything.")},
                   {:event => "nomatch:1 nomatch:2 nomatch:3", :value => say_str("Oops, that wasn't a valid ballot number.")},
                   {:value => say_str("To verify your ballot choice, please enter or say your ballot's serial number followed by the pound key.")}],
                    :choices => { :value => "[1-10 DIGITS]"}
    end

    # Add a 'hangup' to the JSON response and set which resource to go to if a Hangup event occurs on Tropo
    t.on :event => 'hangup', :next => '/hangup.json'
    # Add an 'on' to the JSON response and set which resource to go when the 'ask' is done executing
    t.on :event => 'continue', :next => '/process_input.json'

  # Return the JSON response via HTTP to Tropo
  t.response
end

# The next step in the session is posted to this resource when the 'ask' is completed in 'index.json'
post '/process_input.json' do
  # Fetch the HTTP Body (the session) of the POST and parse it into a native Ruby Hash object
  v = Tropo::Generator.parse request.env["rack.input"].read

  # Create a Tropo::Generator object which is used to build the resulting JSON response
  t = Tropo::Generator.new
    t.voice = settings.tropo_tts["voice"]
    # If no intial text was captured, use the input in response to the ask in the previous route
    unless session[:input]
      if v[:result] && v[:result][:actions] && v[:result][:actions][:input]
        session[:input] = v[:result][:actions][:input][:value].gsub(" ","")
      else
      end
    end

    all_ballots = load_spreadsheet_into_hash
    # matched_ballot gets set to the FIRST ballot found with the given serial number
    matched_ballot = all_ballots.find {|ballot| ballot['Serial Number'] == session[:input] }
    session[:data] = matched_ballot
    G.event("VerifyVote", "LookupByInput", session[:input].to_s) if defined?(G)

    if session[:data] # is not null
      t.say say_str("Here is your ballot record: #{matched_ballot.inspect}")
    else
      # Add a 'say' to the JSON response and hangip the call
      t.say say_str("Sorry, but we did not find a ballot with your serial number.")
    end

    t.on  :event => 'continue', :next => '/goodbye.json'
    t.on  :event => 'hangup', :next => '/goodbye.json'

  t.response
end

# The next step in the session is posted to this resource when the 'ask' is completed in 'send_text_message.json'
post '/goodbye.json' do
  # Fetch the HTTP Body (the session) of the POST and parse it into a native Ruby Hash object
  v = Tropo::Generator.parse request.env["rack.input"].read

  # Create a Tropo::Generator object which is used to build the resulting JSON response
  t = Tropo::Generator.new
    t.voice = settings.tropo_tts["voice"]
    puts session.inspect
    if session["channel"] == "VOICE"
      t.say say_str("Thank you for verifying your vote. This service provided by social health insights dot com,, Have a nice day. Goodbye.")
    else # For text users, we can give them a URL (most clients will make the links clickable)
      t.say "Thank you for verifying your vote. This service by http://SocialHealthInsights.com"
    end
    t.hangup

    # Add a 'hangup' to the JSON response and set which resource to go to if a Hangup event occurs on Tropo
    t.on  :event => 'hangup', :next => '/hangup.json'
  t.response
end

# The next step in the session is posted to this resource when any of the resources do a hangup
post '/hangup.json' do
  v = Tropo::Generator.parse request.env["rack.input"].read
  G.event("VerifyVote", "Hangup", "Duration", v[:result][:session_duration].to_s) if defined?(G)
  puts " Call complete (CDR received). Call duration: #{v[:result][:session_duration]} second(s)"
end

require "rubygems"
require "bundler"
RACK_ENV = (ENV['RACK_ENV'] || :development).to_sym
Bundler.require(:default, RACK_ENV)

require "logger"

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

class SquirrelSupply < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  use Rack::Deflater

  layout :main
  configure do
    connections = {
      :development => "postgres://localhost/squirrel",
      :test => "postgres://postgres@localhost/squirrel_test",
      :production => ENV['DATABASE_URL']
    }

    url = URI(connections[RACK_ENV])
    options = {
      :adapter => url.scheme,
      :host => url.host,
      :port => url.port,
      :database => url.path[1..-1],
      :username => url.user,
      :password => url.password
    }

    case url.scheme
    when "sqlite"
      options[:adapter] = "sqlite3"
      options[:database] = url.host + url.path
    when "postgres"
      options[:adapter] = "postgresql"
    end
    set :database, options

    use Rack::Session::Cookie, :key => 'rack.session',
      :path => '/',
      :expire_after => 86400, # 1 day
      :secret => ENV['SESSION_SECRET'] || '*&(^B234'
  end

  get "/" do
    if session[:auth]
      erb :home, layout: "layouts/main".to_sym
    else
      erb :login, layout: "layouts/main".to_sym
    end
  end

  post "/login" do
    if Auth.check(params["pass"])
      session[:auth] = true
    else
      session[:auth] = nil
    end

    redirect "/"
  end
end

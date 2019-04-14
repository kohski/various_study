require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'rack/csrf'

use Rack::Session::Cookie, secret: "thissisomethingsecret"
use Rack::Csrf, raise: true

helpers do
  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end

  def csrf_token
    Rack::Csrf.csrf_token(env)
  end

  def h(str)
    Rack::Utils.escape_html(str)
  end
end


ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './bbs.db'
)

class Comment < ActiveRecord::Base
  validates :body, presence: true
end


get '/' do
  @title = 'My BBS'
  @comments = Comment.all
  erb :index
end

post '/create' do
  Comment.create(body: params[:body])
  redirect to('/')
end

post '/destroy' do
  Comment.find(params[:id]).destroy
end




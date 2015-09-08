require './config/environment'
require './app/models/tweet'
require 'pry'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    @tweets = Tweet.all
    erb :index
  end

  get '/tweet' do
    erb :tweet
  end

  post '/tweet' do
    tweet = Tweet.new({:username => params[:username], :status => params[:status]}) 
    tweet.save 
    redirect '/'
  end

end

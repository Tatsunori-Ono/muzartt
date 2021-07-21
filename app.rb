require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require './models'

enable :sessions

before do
    if !current_user && !["/", "/signin", "/signup", "/mailing_list"].include?(request.path_info)  
        redirect '/'
    end
end

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

get '/' do
    erb :home
end

get '/signin' do
    erb :sign_in
end

get '/signup' do
    erb :sign_up
end

get '/mailing_list' do
   erb :home
end

post '/signin' do
    user = User.find_by(mail: params[:mail])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
    redirect '/'
end

post '/signup' do
    @user = User.create(name_first:params[:name_first], name_last:params[:name_last], mail:params[:mail], password:params[:password],password_confirmation:params[:password_confirmation])
    if @user.persisted?
        session[:user] = @user.id
    end
    redirect '/'
end

get '/signout' do
    session[:user] = nil
    redirect '/'
end

post '/mailing_list' do
    @mailing_list = Mailing_list.create(name:params[:name], phone_number:params[:phone_number], mail:params[:email], message:params[:message])
    redirect '/'
end